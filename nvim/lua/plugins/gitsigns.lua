require('gitsigns').setup({

  -- Ký hiệu hiển thị ở sign column
  signs = {
    add          = { text = '▎' },
    change       = { text = '▎' },
    delete       = { text = '' },
    topdelete    = { text = '' },
    changedelete = { text = '▎' },
    untracked    = { text = '┆' },
  },

  -- Ký hiệu cho hunk đã staged (khác màu với unstaged)
  signs_staged = {
    add          = { text = '▎' },
    change       = { text = '▎' },
    delete       = { text = '' },
    topdelete    = { text = '' },
    changedelete = { text = '▎' },
  },
  signs_staged_enable = true,

  -- Hiện blame của dòng hiện tại ở cuối dòng
  current_line_blame = true,
  current_line_blame_opts = {
    virt_text     = true,
    virt_text_pos = 'eol',   -- 'eol' | 'right_align' | 'overlay'
    delay         = 800,     -- ms trước khi hiện
  },

  -- Keymaps — chỉ active trong buffer có git
  on_attach = function(bufnr)
    local gs = require('gitsigns')

    local function map(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
    end

    -- Navigation: nhảy giữa các hunk
    map('n', ']h', function()
      if vim.wo.diff then
        vim.cmd.normal({ ']c', bang = true })
      else
        gs.nav_hunk('next')
      end
    end, 'Next Hunk')

    map('n', '[h', function()
      if vim.wo.diff then
        vim.cmd.normal({ '[c', bang = true })
      else
        gs.nav_hunk('prev')
      end
    end, 'Prev Hunk')

    map('n', ']H', function() gs.nav_hunk('last') end,  'Last Hunk')
    map('n', '[H', function() gs.nav_hunk('first') end, 'First Hunk')

    -- Stage / reset hunk (normal + visual mode)
    map({ 'n', 'v' }, '<leader>ghs', ':Gitsigns stage_hunk<CR>',  'Stage Hunk')
    map({ 'n', 'v' }, '<leader>ghr', ':Gitsigns reset_hunk<CR>',  'Reset Hunk')

    -- Stage / reset toàn bộ buffer
    map('n', '<leader>ghS', gs.stage_buffer,  'Stage Buffer')
    map('n', '<leader>ghR', gs.reset_buffer,  'Reset Buffer')

    -- Undo stage hunk vừa stage
    map('n', '<leader>ghu', gs.undo_stage_hunk, 'Undo Stage Hunk')

    -- Preview hunk
    map('n', '<leader>ghp', gs.preview_hunk,        'Preview Hunk Popup')
    map('n', '<leader>ghi', gs.preview_hunk_inline,  'Preview Hunk Inline')

    -- Blame
    map('n', '<leader>ghb', function()
      gs.blame_line({ full = true })
    end, 'Blame Line')
    map('n', '<leader>ghB', gs.blame, 'Blame Buffer')

    -- Toggle
    map('n', '<leader>ghd', gs.diffthis, 'Diff This')
    map('n', '<leader>ub',  gs.toggle_current_line_blame, 'Toggle Line Blame')
    map('n', '<leader>uD',  gs.toggle_deleted, 'Toggle Show Deleted')

    -- Text object: chọn hunk như text object (dùng trong visual/operator mode)
    map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', 'Select Hunk')
  end,
})
