vim.pack.add({
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/mason-org/mason.nvim",
  "https://github.com/mason-org/mason-lspconfig.nvim",
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
  "https://github.com/stevearc/conform.nvim",

  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/nvim-telescope/telescope.nvim",
  "https://github.com/nvim-telescope/telescope-file-browser.nvim",

  "https://github.com/christoomey/vim-tmux-navigator",

  "https://github.com/catppuccin/nvim",

  "https://github.com/NMAC427/guess-indent.nvim",
  "https://github.com/m4xshen/autoclose.nvim",

  "https://github.com/lewis6991/gitsigns.nvim",

  "https://github.com/nvim-lualine/lualine.nvim",
  "https://github.com/folke/trouble.nvim",

  -- Workflow plugins carried over from the previous lazy.nvim config.
  -- vim-test and code_runner both dispatch into a tmux pane via vimux.
  "https://github.com/vim-test/vim-test",
  "https://github.com/preservim/vimux",
  "https://github.com/CRAG666/code_runner.nvim",
  "https://github.com/rmagatti/auto-session",

  -- Deferred: packadd'd on first <leader>gg press (see plugins/lazygit.lua)
  { src = "https://github.com/kdheepak/lazygit.nvim", load = false },
})

require("plugins.lsp")
require("plugins.diagnostics")
require("plugins.formatter")
require("plugins.telescope")
require("plugins.colorscheme")
require("plugins.gitsigns")
require("plugins.treesitter")
require("plugins.ui")
require("plugins.tmux-nav")
require("plugins.trouble")
require("plugins.lazygit")
require("plugins.test")
require("plugins.runner")
require("plugins.session")

require("plugins.startpage")
require("guess-indent").setup({ auto_cmd = true })
require("autoclose").setup()
