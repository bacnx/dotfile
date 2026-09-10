require('telescope').setup({
  defaults = {
    -- 'flex' picks horizontal when there is room, vertical when there is not,
    -- so a narrow tmux pane gets a preview stacked below instead of none at all.
    layout_strategy = 'flex',
    layout_config = {
      -- Below this many columns, flex flips to the vertical layout.
      flex = { flip_columns = 130 },
      -- preview_cutoff defaults to 120 and silently hides the preview under it.
      horizontal = { preview_width = 0.55, preview_cutoff = 0 },
      vertical = { preview_height = 0.5, preview_cutoff = 0 },
    },
    file_ignore_patterns = { 'node_modules/', '%.git/' },
    mappings = {
      i = {
        ['<C-k>'] = 'move_selection_previous',
        ['<C-j>'] = 'move_selection_next',
      },
    },
  },
  pickers = {
    find_files = { hidden = true },
    live_grep = {
      additional_args = function()
        return { '--hidden' }
      end,
    },
  },
  extensions = {
      file_browser = {
      hijack_netrw = true,
      hidden = true,
    },
  },
})

local keymap = vim.keymap.set
local builtin = require('telescope.builtin')
keymap('n', '<leader>ff', builtin.find_files, { desc = 'Find files' })
keymap('n', '<leader>fg', builtin.live_grep,  { desc = 'Live grep' })
keymap('n', '<leader>fb', builtin.buffers,    { desc = 'Buffers' })

-- Same pickers, but ignoring .gitignore (dist/, build/, node_modules/, ...)
keymap('n', '<leader>fa', function()
  builtin.find_files({
    hidden = true,
    no_ignore = true,
    file_ignore_patterns = { '%.git/' },
  })
end, { desc = 'Find files (no ignore)' })
keymap('n', '<leader>fG', function()
  builtin.live_grep({ additional_args = function()
    return { '--hidden', '--no-ignore' }
  end })
end, { desc = 'Live grep (no ignore)' })

require('telescope').load_extension('file_browser')
keymap('n', '<leader>fs', function()
  require('telescope').extensions.file_browser.file_browser({
    path = '%:p:h',
    select_buffer = true,
  })
end)
