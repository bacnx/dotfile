-- Run :TSUpdate automatically after nvim-treesitter is updated
vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    if ev.data.spec.name == 'nvim-treesitter' and ev.data.kind == 'update' then
      -- If plugin wasn't active this session, load it first
      if not ev.data.active then
        vim.cmd.packadd('nvim-treesitter')
      end
      vim.cmd('TSUpdate')
    end
  end,
})

-- ============================================================
-- TREESITTER PARSERS
-- Install once with :TSInstall, then they persist
-- ============================================================
-- Ensure these parsers are always installed
require('nvim-treesitter').setup({
  ensure_installed = { 'go', 'lua', 'javascript', 'sql' },
  sync_install     = false,
  auto_install     = false,

  -- Disable built-in modules — we handle highlight/indent ourselves below
  highlight        = { enable = false },
  indent           = { enable = false },
})

-- ============================================================
-- TREESITTER HIGHLIGHTING (your original config, slightly improved)
-- ============================================================
vim.api.nvim_create_autocmd('FileType', {
  callback = function(args)
    local lang = vim.treesitter.language.get_lang(args.match)
    -- Only start if a parser for this language actually exists
    if lang and vim.treesitter.language.add(lang) then
      vim.treesitter.start()
    end
  end,
})
