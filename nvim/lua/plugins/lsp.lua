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

-- ESLint runs as a linter only. `format = true` (the lspconfig default) makes the
-- server advertise document formatting, which would put it in competition with
-- conform for js/ts buffers; formatting is biome's or prettier's job here.
--
-- No gating needed beyond this: the server's own root_dir returns nil unless it
-- finds an .eslintrc*/eslint.config.* above the file, so eslint simply never
-- attaches in a repo that isn't using it.
vim.lsp.config("eslint", {
  settings = { format = false },
})

require("mason-lspconfig").setup({
  ensure_installed = { "lua_ls", "ts_ls", "gopls", "sqls", "eslint" },
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
    -- Hover lives on K, not <C-k>: a buffer-local <C-k> would shadow the global
    -- TmuxNavigateUp mapping in every LSP-attached buffer.
    vim.keymap.set("n", "K",        vim.lsp.buf.hover,           { buffer = buf, desc = "LSP hover" })
    vim.keymap.set("i", "<M-s>",    vim.lsp.buf.signature_help,  { buffer = buf, desc = "LSP signature help" })
    -- These four use the vim API rather than telescope's LSP pickers. Those
    -- pickers run server results through defaults.file_ignore_patterns, where
    -- 'node_modules/' drops every hit in a dependency: gd reported "No LSP
    -- Definitions found" as though the server had returned nothing, and gr
    -- quietly thinned the reference list with no indication it had. The vim
    -- API pushes the tagstack and jumplist just as the pickers did, so
    -- <C-t>/<C-o> are unaffected; multiple results open the quickfix list
    -- instead of a fuzzy picker.
    vim.keymap.set("n", "gd",    vim.lsp.buf.definition,      { buffer = buf, desc = "Go to definition" })
    vim.keymap.set("n", "gi",    vim.lsp.buf.implementation,  { buffer = buf, desc = "Go to implementation" })
    vim.keymap.set("n", "gr",    vim.lsp.buf.references,      { buffer = buf, desc = "Go to references" })
    vim.keymap.set("n", "gD",    vim.lsp.buf.declaration,     { buffer = buf, desc = "Go to declaration" })

    -- LspEslintFixAll is a buffer command created by eslint's own on_attach, so
    -- only bind it on buffers where eslint is the client that just attached.
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client.name == "eslint" then
      vim.keymap.set("n", "<leader>ce", "<cmd>LspEslintFixAll<cr>",
        { buffer = buf, desc = "ESLint fix all" })
    end
  end,
})
