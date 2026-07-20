-- Helper: load plugin on first keypress, then re-invoke the key
local function tmux_nav(cmd)
  return function()
    vim.cmd.packadd('vim-tmux-navigator')
    vim.cmd(cmd)
  end
end

local map = vim.keymap.set
local opts = { silent = true }

map('n', '<C-h>',     tmux_nav('TmuxNavigateLeft'),  opts)
map('n', '<C-j>',     tmux_nav('TmuxNavigateDown'),  opts)
map('n', '<C-k>',     tmux_nav('TmuxNavigateUp'),    opts)
map('n', '<C-l>',     tmux_nav('TmuxNavigateRight'), opts)
map('n', '<C-Left>',  tmux_nav('TmuxNavigateLeft'),  opts)
map('n', '<C-Down>',  tmux_nav('TmuxNavigateDown'),  opts)
map('n', '<C-Up>',    tmux_nav('TmuxNavigateUp'),    opts)
map('n', '<C-Right>', tmux_nav('TmuxNavigateRight'), opts)
