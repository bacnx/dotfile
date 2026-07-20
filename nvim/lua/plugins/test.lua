-- vim-test dispatches into a tmux pane via vimux
vim.g["test#strategy"] = "vimux"

-- NOTE: the test family lives on <leader>T, not <leader>t — the lowercase prefix
-- is taken by the conform format-on-save toggles (<leader>tf / <leader>tF).
local map = vim.keymap.set

map("n", "<leader>Tt", "<cmd>TestNearest<CR>", { silent = true, desc = "Test nearest" })
map("n", "<leader>Tf", "<cmd>TestFile<CR>", { silent = true, desc = "Test file" })
map("n", "<leader>Ta", "<cmd>TestSuite<CR>", { silent = true, desc = "Test suite" })
map("n", "<leader>Tl", "<cmd>TestLast<CR>", { silent = true, desc = "Test last" })
map("n", "<leader>Tg", "<cmd>TestVisit<CR>", { silent = true, desc = "Visit last test file" })
