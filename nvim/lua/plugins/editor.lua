return {
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.8',
        lazy = false,
        dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-telescope/telescope-file-browser.nvim',
            'smartpde/telescope-recent-files',
        },
        keys = {
            {
                ';f',
                function()
                    local builtin = require('telescope.builtin')
                    builtin.find_files()
                end,
                desc = 'List file in current working directory',
            },
            {
                'sf',
                function()
                    local telescope = require('telescope')
                    local function telescope_buffer_dir()
                        return vim.fn.expand('%:p:h')
                    end

                    telescope.extensions.file_browser.file_browser({
                        path = '%:p:h',
                        cwd = telescope_buffer_dir(),
                        respect_gitignore = false,
                        hidden = true,
                        grouped = true,
                        previewer = false,
                        initial_mode = 'normal',
                        layout_config = { height = 40 },
                    })
                end,
                desc = 'Open File browser with the path of the current buffer',
            },
            {
                ';r',
                function()
                    local builtin = require('telescope.builtin')
                    builtin.live_grep()
                end,
                desc = 'Search for a string in your current working directory and get result live as you type',
            },
            {
                ';;',
                function()
                    local builtin = require('telescope.builtin')
                    builtin.resume()
                end,
                desc = 'Resume the previous telescope picker',
            },
            {
                ';b',
                function()
                    local builtin = require('telescope.builtin')
                    builtin.buffers()
                end,
                desc = 'Lists open buffers',
            },
        },
        opts = {
            defaults = {
                wrap_results = true,
                layout_strategy = 'horizontal',
                layout_config = { prompt_position = 'top' },
                sorting_strategy = 'ascending',
                file_ignore_patterns = { '.git/' },
                winblend = 0,
            },
            pickers = {
                find_files = {
                    hidden = true,
                },
                buffers = {
                    initial_mode = 'normal',
                },
            },
        },
    },
    {
        'rmagatti/auto-session',
        dependencies = 'nvim-telescope/telescope.nvim',
        opts = {
            log_level = 'error',

            cwd_change_handling = {
                restore_upcoming_session = true,
                post_cwd_changed_hook = function()
                    require('lualine').refresh()
                end,
            },
        },
    },
    {
        'lewis6991/gitsigns.nvim',
        opts = {},
    },
    {
        'kdheepak/lazygit.nvim',
        cmd = {
            'LazyGit',
            'LazyGitConfig',
            'LazyGitCurrentFile',
            'LazyGitFilter',
            'LazyGitFilterCurrentFile',
        },
        dependencies = {
            'nvim-lua/plenary.nvim',
        },
        keys = {
            { '<leader>gg', '<cmd>LazyGit<cr>', desc = 'LazyGit' },
        },
    },
    {
        'christoomey/vim-tmux-navigator',
        cmd = {
            'TmuxNavigateLeft',
            'TmuxNavigateDown',
            'TmuxNavigateUp',
            'TmuxNavigateRight',
            'TmuxNavigatePrevious',
        },
        keys = {
            { '<c-h>', '<cmd><C-U>TmuxnavigateLeft<cr>' },
            { '<c-j>', '<cmd><C-U>TmuxnavigateDown<cr>' },
            { '<c-k>', '<cmd><C-U>TmuxnavigateUp<cr>' },
            { '<c-l>', '<cmd><C-U>TmuxnavigateRight<cr>' },
            { '<c-\\>', '<cmd><C-U>TmuxnavigatePrevious<cr>' },
        },
    },
    {
        'vim-test/vim-test',
        dependencies = 'preservim/vimux',
        keys = {
            { '<leader>tt', ':TestNearest<CR>' },
            { '<leader>tf', ':TestFile<CR>' },
            { '<leader>ta', ':TestSuite<CR>' },
            { '<leader>tl', ':TestLast<CR>' },
            { '<leader>tg', ':TestVisit<CR>' },
        },
        config = function()
            vim.cmd('let test#strategy = "vimux"')
        end,
    },
    {
        'CRAG666/code_runner.nvim',
        dependencies = 'preservim/vimux',
        keys = {
            { '<leader>r', ':RunCode<CR>', desc = 'Runs based on file type' },
        },
        opts = {
            hot_reload = false,
            mode = 'vimux',
            filetype = {
                typescript = {
                    'cd $dir &&',
                    'tsc $fileName &&',
                    'node $fileNameWithoutExt.js',
                },
                go = {
                    'cd $dir &&',
                    'go run main.go',
                },
                zig = {
                    'cd $dir &&',
                    'zig run $fileName',
                },
            },
        },
    },
    {
        'windwp/nvim-ts-autotag',
        opts = {
            opts = {
                enable_close = true,
                enable_rename = true,
            },
            autotag = { enable = true },
        },
    },
    {
        'm4xshen/hardtime.nvim',
        lazy = false,
        dependencies = 'MunifTanjim/nui.nvim',
        opts = {},
    },
}
