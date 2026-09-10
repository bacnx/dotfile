vim.opt.completeopt = "menu,menuone,noselect,popup,nearest"
vim.o.autocomplete = true

vim.api.nvim_create_autocmd("FileType", {
  pattern = "TelescopePrompt",
  callback = function()
    vim.opt_local.autocomplete = false
  end,
})

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client.id, args.buf, {
        autotrigger = true,
      })
    end
  end,
})

-- bin/clip from this repo (symlinked to ~/.local/bin/clip) picks the backend --
-- clip.exe / win32yank on WSL, wl-copy on Wayland, xclip or xsel on X11 -- so
-- the choice is made in one place shared with .zshrc and tmux.
vim.g.clipboard = {
  name = "clip",
  copy = {
    ["+"] = "clip -i",
    ["*"] = "clip -i",
  },
  paste = {
    ["+"] = "clip -o",
    ["*"] = "clip -o",
  },
  cache_enabled = 0,
}
vim.opt.clipboard = "unnamedplus"

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"

opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smartindent = true

opt.wrap = true
opt.scrolloff = 8
opt.sidescrolloff = 8

opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

opt.splitbelow = true
opt.splitright = true

opt.termguicolors = true
opt.cursorline = true

opt.undofile = true
opt.swapfile = false
opt.backup = false

opt.updatetime = 250
opt.timeoutlen = 500
