local keymap = vim.keymap
local opts = { noremap = true, silent = true }
local function extend_opts(custom_opts)
    return vim.tbl_extend('force', opts, custom_opts)
end

local function reload_buffer()
    -- Store current buffer's file path
    local current_buf = vim.api.nvim_get_current_buf()
    local current_file = vim.api.nvim_buf_get_name(current_buf)

    -- Save the buffer if it has a file associated and is modified
    if current_file ~= '' and vim.api.nvim_buf_get_option(current_buf, 'modified') then
        vim.api.nvim_buf_call(current_buf, function()
            vim.cmd('write')
        end)
    end

    -- Delete the current buffer
    vim.api.nvim_buf_delete(current_buf, { force = true })

    -- Reopen the file if it exists
    if current_file ~= '' then
        vim.cmd('edit ' .. vim.fn.fnameescape(current_file))
    end
end

-- Remap leader with <space>
vim.g.mapleader = ' '

keymap.set('i', 'jk', '<esc>', opts)
keymap.set('n', '<leader>w', ':write <Return>', opts)
keymap.set('n', '<leader>q', ':quitall <Return>', extend_opts({ desc = 'Quit nvim' }))
keymap.set('n', '<leader>e', reload_buffer, extend_opts({ desc = 'Reload current buffer' }))

-- Buffers
keymap.set('n', 'te', ':enew <Return>', { desc = 'Create a new unnamed buffer on current window' })
keymap.set('n', '<Tab>', ':bnext <Return>', extend_opts({ desc = 'Next buffer' }))
keymap.set('n', '<S-Tab>', ':bprevious <Return>', extend_opts({ desc = 'Previous buffer' }))
keymap.set('n', 'tq', ':bdelete <Return>', extend_opts({ desc = 'Delete buffer' }))
keymap.set('n', '<leader><leader>', ':b# <Return>', extend_opts({ desc = 'Switch to last edited buffer' }))

keymap.set('n', 'tc', ':close <Return>', extend_opts({ desc = 'Close current pane' }))

-- Split window
keymap.set('n', 'ss', ':split<Return><C-w>w', opts)
keymap.set('n', 'sv', ':vsplit<Return><C-w>w', opts)

-- Clear search with <esc>
keymap.set({ 'i', 'n' }, '<esc>', '<cmd>noh<cr><esc>', extend_opts({ desc = 'Escape and Clear hlsearch' }))

-- Git
keymap.set(
    'n',
    '<leader>gd',
    ':args `git ls-files -m -o --exclude-standard` <Return>',
    extend_opts({ desc = 'Add untracked/modifiled files to argument list' })
)
keymap.set('n', '<leader>ga', ':!git add % <Return>', extend_opts({ desc = 'Stage current file' }))
keymap.set('n', '<leader>gr', ':!git restore --staged % <Return>', extend_opts({ desc = 'Unstage current file' }))
