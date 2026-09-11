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
    -- Web filetypes: biome and prettier are both gated on the repo actually
    -- carrying their config file (see require_cwd below), so a repo with
    -- neither gets no formatter at all. lsp_format = 'never' keeps ts_ls from
    -- stepping in with its own style when that happens.
    javascript = { 'biome', 'prettier', stop_after_first = true, lsp_format = 'never' },
    typescript = { 'biome', 'prettier', stop_after_first = true, lsp_format = 'never' },
    json       = { 'biome', 'prettier', stop_after_first = true, lsp_format = 'never' },
    -- .jsx / .tsx are their own filetypes, not a suffix of the two above — without
    -- these entries they fall through to default_format_opts and ts_ls formats them.
    javascriptreact = { 'biome', 'prettier', stop_after_first = true, lsp_format = 'never' },
    typescriptreact = { 'biome', 'prettier', stop_after_first = true, lsp_format = 'never' },
    css        = { 'prettier', lsp_format = 'never' },
    html       = { 'prettier', lsp_format = 'never' },
    markdown   = { 'prettier', lsp_format = 'never' },
    yaml       = { 'prettier', lsp_format = 'never' },
    sh         = { 'shfmt' },
    toml       = { 'taplo' },
  },

  -- Applies to any filetype that doesn't set lsp_format itself, including the
  -- ones with no entry above. ('_' = { 'lsp' } does not work: conform has no
  -- formatter named "lsp" — LSP formatting is only ever reached via this option.)
  default_format_opts = { lsp_format = 'fallback' },

  -- Format on save
  format_on_save = function(bufnr)
    -- Disable format-on-save per buffer (set vim.b.disable_autoformat = true)
    if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
      return
    end
    -- No lsp_format here on purpose: options set at the call site win over
    -- the per-filetype ones, which would defeat lsp_format = 'never' above.
    return { timeout_ms = 500 }
  end,

  -- Notify on error (useful while setting up new formatters)
  notify_on_error     = true,
  notify_no_formatters = false, -- too noisy for unregistered filetypes
})

-- ============================================================
-- FORMATTER GATING
-- ============================================================
-- Both tools ship a `cwd` that locates the repo root by its own config file
-- (biome.json{,c} / .biome.json{,c} for biome; .prettierrc*, prettier.config.*
-- or a "prettier" key in package.json for prettier). require_cwd turns "no
-- config found" into "formatter unavailable", which means:
--   * a biome repo uses biome, a prettier repo uses prettier — stop_after_first
--     now falls through instead of always picking biome just because Mason put
--     it on $PATH;
--   * a repo configured for neither is left alone on save.
conform.formatters.biome = { require_cwd = true }
conform.formatters.prettier = { require_cwd = true }

-- Make gq use conform instead of the default formatexpr
vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

-- ============================================================
-- KEYMAPS
-- ============================================================

-- Manual format (normal = whole file, visual = selection)
vim.keymap.set({ 'n', 'v' }, '<leader>cf', function()
  conform.format({ async = true })
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
