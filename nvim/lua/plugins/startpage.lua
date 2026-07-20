local session_file = vim.fn.stdpath("state") .. "/startpage_session.json"

local function cwd_short()
  local cwd = vim.fn.getcwd()
  local home = vim.fn.expand("~")
  return cwd:sub(1, #home) == home and "~" .. cwd:sub(#home + 1) or cwd
end

local function recent_files()
  local cwd = vim.fn.getcwd() .. "/"
  local files = {}
  for _, path in ipairs(vim.v.oldfiles) do
    if path:sub(1, #cwd) == cwd and vim.fn.filereadable(path) == 1 then
      files[#files + 1] = path
      if #files == 10 then break end
    end
  end
  return files
end

local function save_session()
  local bufs = {}
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) then
      local name = vim.api.nvim_buf_get_name(buf)
      if name ~= "" and vim.bo[buf].buftype == "" then
        bufs[#bufs + 1] = name
      end
    end
  end
  local ok, encoded = pcall(vim.json.encode, bufs)
  if not ok then return end
  local f = io.open(session_file, "w")
  if f then
    f:write(encoded)
    f:close()
  end
end

local function restore_session()
  local f = io.open(session_file, "r")
  if not f then
    vim.notify("No saved session", vim.log.levels.INFO)
    return
  end
  local content = f:read("*a")
  f:close()
  local ok, paths = pcall(vim.json.decode, content)
  if not ok or type(paths) ~= "table" or #paths == 0 then
    vim.notify("Session is empty", vim.log.levels.INFO)
    return
  end
  for i, path in ipairs(paths) do
    if vim.fn.filereadable(path) == 1 then
      if i == 1 then
        vim.cmd.edit(path)
      else
        vim.cmd.badd(path)
      end
    end
  end
end

local function open_startpage()
  local files = recent_files()
  local cwd = vim.fn.getcwd()

  local lines = { "", "", "  " .. cwd_short(), "", "  recent files", "  " .. ("─"):rep(30) }

  local first_file_line = #lines + 1
  local slots = {}
  local line_to_slot = {}

  for i, path in ipairs(files) do
    local label = tostring(i == 10 and 0 or i)
    local rel = path:sub(#cwd + 2)
    lines[#lines + 1] = "  " .. label .. "  " .. rel
    slots[i] = path
    line_to_slot[#lines] = i
  end

  local last_file_line = #lines

  if #files == 0 then
    lines[#lines + 1] = "  (no recent files in cwd)"
  end

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_set_current_buf(buf)

  vim.bo[buf].buftype   = "nofile"
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].buflisted = false
  vim.bo[buf].swapfile  = false
  vim.bo[buf].filetype  = "startpage"

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = false

  if #files > 0 then
    vim.api.nvim_win_set_cursor(0, { first_file_line, 2 })
  end

  local map = function(lhs, rhs)
    vim.keymap.set("n", lhs, rhs, { buffer = buf, noremap = true, silent = true })
  end

  for slot, path in ipairs(slots) do
    local key = tostring(slot == 10 and 0 or slot)
    map(key, function() vim.cmd.edit(path) end)
  end

  map("<CR>", function()
    local row = vim.api.nvim_win_get_cursor(0)[1]
    local slot = line_to_slot[row]
    if slot and slots[slot] then vim.cmd.edit(slots[slot]) end
  end)

  local function move_down()
    local row = vim.api.nvim_win_get_cursor(0)[1]
    if row < last_file_line then
      vim.api.nvim_win_set_cursor(0, { row + 1, 2 })
    end
  end

  local function move_up()
    local row = vim.api.nvim_win_get_cursor(0)[1]
    if row > first_file_line then
      vim.api.nvim_win_set_cursor(0, { row - 1, 2 })
    end
  end

  -- arrows are the primary movement here; j/k stay bound as a fallback
  map("j", move_down)
  map("<Down>", move_down)
  map("k", move_up)
  map("<Up>", move_up)

  map("q", function() vim.cmd.bdelete() end)
  map("r", restore_session)
  map("<leader>ff", "<cmd>Telescope find_files<CR>")
end

vim.api.nvim_create_autocmd("VimLeave", { callback = save_session })

vim.api.nvim_create_autocmd("VimEnter", {
  once = true,
  callback = function()
    if vim.fn.argc() == 0 then
      open_startpage()
    end
  end,
})
