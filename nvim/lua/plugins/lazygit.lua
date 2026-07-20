-- lazygit.nvim is added with load = false; packadd on first use.
vim.keymap.set("n", "<leader>gg", function()
  vim.cmd.packadd("lazygit.nvim")
  vim.cmd("LazyGit")
end, { silent = true, desc = "LazyGit" })
