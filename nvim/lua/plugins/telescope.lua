require('telescope').setup({
  defaults = {
    layout_strategy = 'horizontal',
    file_ignore_patterns = { 'node_modules', '.git' },
    mappings = {
      i = {
        ['<C-k>'] = 'move_selection_previous',
        ['<C-j>'] = 'move_selection_next',
      },
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

require('telescope').load_extension('file_browser')
keymap('n', '<leader>fs', function()
  require('telescope').extensions.file_browser.file_browser({
    path = '%:p:h',
    select_buffer = true,
  })
end)
