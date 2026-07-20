require("mason").setup()

-- Tell all LSP servers the client supports rich completions (snippets, resolve, etc.)
-- This must run before mason-lspconfig starts any server.
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = { "documentation", "detail", "additionalTextEdits" },
}
vim.lsp.config("*", { capabilities = capabilities })

vim.lsp.config("gopls", {
  settings = {
    gopls = {
      hoverKind      = "FullDocumentation",
      importShortcut = "Both",
      linksInHover   = true,
      directoryFilters = { "-.git" },
    },
  },
})

require("mason-lspconfig").setup({
  ensure_installed = { "lua_ls", "ts_ls", "gopls", "sqls" },
  automatic_enable = true,
})

-- Auto-install formatters (non-LSP tools) via Mason registry
local mr = require("mason-registry")
local formatters = { "stylua", "ruff", "black", "biome", "prettier", "shfmt", "taplo" }
mr.refresh(function()
  for _, name in ipairs(formatters) do
    local ok, pkg = pcall(mr.get_package, name)
    if ok and not pkg:is_installed() then
      pkg:install()
    end
  end
end)

vim.lsp.handlers["textDocument/hover"] = function(err, result, ctx, config)
  vim.lsp.handlers.hover(err, result, ctx, vim.tbl_extend("force", config or {}, {
    border    = "rounded",
    title     = " Documentation",
    title_pos = "center",
    max_width = 80,
    max_height = 20,
    focusable = true,
  }))
end

vim.lsp.handlers["textDocument/signatureHelp"] = function(err, result, ctx, config)
  vim.lsp.handlers.signature_help(err, result, ctx, vim.tbl_extend("force", config or {}, {
    border    = "rounded",
    title     = " Signature",
    title_pos = "center",
    focusable = false,
  }))
end

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local buf = args.buf
    local builtin = require("telescope.builtin")
    -- Hover lives on K, not <C-k>: a buffer-local <C-k> would shadow the global
    -- TmuxNavigateUp mapping in every LSP-attached buffer.
    vim.keymap.set("n", "K",        vim.lsp.buf.hover,           { buffer = buf, desc = "LSP hover" })
    vim.keymap.set("i", "<M-s>",    vim.lsp.buf.signature_help,  { buffer = buf, desc = "LSP signature help" })
    vim.keymap.set("n", "gd",    builtin.lsp_definitions,     { buffer = buf, desc = "Go to definition" })
    vim.keymap.set("n", "gi",    builtin.lsp_implementations,  { buffer = buf, desc = "Go to implementation" })
    vim.keymap.set("n", "gr",    builtin.lsp_references,       { buffer = buf, desc = "Go to references" })
    vim.keymap.set("n", "gD",    vim.lsp.buf.declaration,      { buffer = buf, desc = "Go to declaration" })
  end,
})
