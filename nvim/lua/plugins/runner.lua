require("code_runner").setup({
  hot_reload = false,
  mode = "vimux",
  filetype = {
    typescript = {
      "cd $dir &&",
      "tsc $fileName &&",
      "node $fileNameWithoutExt.js",
    },
    go = {
      "cd $dir &&",
      "go run main.go",
    },
    zig = {
      "cd $dir &&",
      "zig run $fileName",
    },
  },
})

vim.keymap.set("n", "<leader>r", "<cmd>RunCode<CR>", { silent = true, desc = "Run file by filetype" })
