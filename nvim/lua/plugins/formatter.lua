-- ============================================================
-- CONFORM — formatter config
-- ============================================================
local conform = require('conform')

conform.setup({
  -- Map filetypes to formatter(s)
  -- Multiple formatters run in sequence (e.g. goimports then gofmt)
  -- stop_after_first = true → use whichever is available first (fallback)
  formatters_by_ft = {
    lua        = { 'stylua' },
    go         = { 'goimports', 'gofmt' },
    python     = { 'ruff_format', 'black', stop_after_first = true },
    javascript = { 'biome', 'prettier', stop_after_first = true },
    typescript = { 'biome', 'prettier', stop_after_first = true },
    json       = { 'biome', 'prettier', stop_after_first = true },
    css        = { 'prettier' },
    html       = { 'prettier' },
    markdown   = { 'prettier' },
    yaml       = { 'prettier' },
    sh         = { 'shfmt' },
    toml       = { 'taplo' },
    -- fallback: use LSP formatter for any filetype not listed above
    ['_']      = { 'lsp' },
  },

  -- Format on save
  -- lsp_format = "fallback" → use LSP if no conform formatter is found for the ft
  format_on_save = function(bufnr)
    -- Disable format-on-save per buffer (set vim.b.disable_autoformat = true)
    if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
      return
    end
    return { timeout_ms = 500, lsp_format = 'fallback' }
  end,

  -- Notify on error (useful while setting up new formatters)
  notify_on_error     = true,
  notify_no_formatters = false, -- too noisy for unregistered filetypes
})

-- Make gq use conform instead of the default formatexpr
vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

-- ============================================================
-- KEYMAPS
-- ============================================================

-- Manual format (normal = whole file, visual = selection)
vim.keymap.set({ 'n', 'v' }, '<leader>cf', function()
  conform.format({ async = true, lsp_format = 'fallback' })
end, { desc = 'Format buffer / range' })

-- Toggle format-on-save globally
vim.keymap.set('n', '<leader>tf', function()
  vim.g.disable_autoformat = not vim.g.disable_autoformat
  vim.notify(
    'Format on save: ' .. (vim.g.disable_autoformat and 'OFF' or 'ON'),
    vim.log.levels.INFO
  )
end, { desc = 'Toggle format-on-save' })

-- Toggle format-on-save for current buffer only
vim.keymap.set('n', '<leader>tF', function()
  vim.b.disable_autoformat = not vim.b.disable_autoformat
  vim.notify(
    'Buffer format on save: ' .. (vim.b.disable_autoformat and 'OFF' or 'ON'),
    vim.log.levels.INFO
  )
end, { desc = 'Toggle format-on-save (buffer)' })

-- Debug: show active formatters and log path
vim.keymap.set('n', '<leader>ci', '<cmd>ConformInfo<cr>', { desc = 'Conform info' })
