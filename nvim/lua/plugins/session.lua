-- auto-session overlaps with the hand-rolled startpage.lua, which saves the buffer
-- list on VimLeave and restores it with `r`. To keep both, auto-session saves
-- automatically but never restores on its own — otherwise it would populate buffers
-- before startpage's VimEnter hook and the start screen would never be the entry point.
require("auto-session").setup({
  log_level = "error",
  auto_save = true,
  auto_restore = false,
  auto_create = true,
})

vim.keymap.set("n", "<leader>sr", "<cmd>SessionRestore<CR>", { silent = true, desc = "Restore session (auto-session)" })
vim.keymap.set("n", "<leader>ss", "<cmd>SessionSave<CR>", { silent = true, desc = "Save session (auto-session)" })
