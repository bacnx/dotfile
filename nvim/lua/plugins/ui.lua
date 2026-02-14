return {
    {
        'nvim-lualine/lualine.nvim',
        dependencies = {
            'nvim-tree/nvim-web-devicons',
            'folke/noice.nvim',
        },
        config = function()
            local theme = require('lualine.themes.auto')
            local muted_fg = '#7a7f8b'
            local muted_bg = theme.normal.c.bg

            for _, mode in ipairs({ 'normal', 'insert', 'visual', 'replace', 'command', 'inactive' }) do
                if theme[mode] and theme[mode].c then
                    theme[mode].c = vim.tbl_extend('force', theme[mode].c, { fg = muted_fg, bg = muted_bg })
                end
            end

            require('lualine').setup({
                options = {
                    icons_enabled = true,
                    theme = theme,
                    component_separators = '',
                },
                sections = {
                    lualine_a = {},
                    lualine_b = {},
                    lualine_c = {
                        'mode',
                        'branch',
                    },

                    lualine_x = {
                        'diagnostics',
                        {
                            require('noice').api.status.mode.get,
                            cond = require('noice').api.status.mode.has,
                        },
                        {
                            require('noice').api.status.search.get,
                            cond = require('noice').api.status.search.has,
                        },
                        'lsp_status',
                        'encoding',
                        'progress',
                        'location',
                    },
                    lualine_y = {},
                    lualine_z = {},
                },
                winbar = {
                    lualine_c = {
                        { 'filetype', icon_only = true },
                        { 'filename', path = 1 },
                        'diff',
                    },
                    lualine_x = {},
                },
                inactive_winbar = {
                    lualine_c = {
                        { 'filetype', icon_only = true },
                        { 'filename', path = 1 },
                        'diff',
                    },
                    lualine_x = {},
                },
            })
        end,
    },
    {
        'folke/noice.nvim',
        event = 'VeryLazy',
        dependencies = {
            'MunifTanjim/nui.nvim',
            'rcarriga/nvim-notify',
            'hrsh7th/nvim-cmp',
        },
        keys = {
            { '<leader>nd', ':NoiceDismiss <CR>', silent = true },
            { '<leader>nl', ':NoiceLast <CR>', silent = true },
            { '<leader>nh', ':NoiceHistory <CR>', silent = true },
        },
        opts = {
            lsp = {
                override = {
                    ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
                    ['vim.lsp.util.stylize_markdown'] = true,
                    ['cmp.entry.get_documentation'] = true,
                },
            },
            presets = {
                bottom_search = true,
                command_palette = true,
                long_message_to_split = true,
                lsp_doc_border = false,
            },
        },
        config = function(_, opts)
            opts.routes = opts.routes or {}
            table.insert(opts.routes, {
                filter = {
                    event = 'notify',
                    any = {
                        { find = 'No information available' },
                        { find = 'Plugin Updates' },
                    },
                },
                opts = { skip = true },
            })

            require('noice').setup(opts)
            require('notify').setup({
                background_colour = '#000000',
            })
        end,
    },
    {
        'folke/trouble.nvim',
        opts = {},
        cmd = 'Trouble',
        keys = {
            {
                '<leader>xx',
                '<cmd>Trouble diagnostics toggle<cr>',
                desc = 'Diagnostics (Trouble)',
            },
            {
                '<leader>xX',
                '<cmd>Trouble diagnostics toggle filter.buf=0<cr>',
                desc = 'Buffer Diagnostics (Trouble)',
            },
            {
                '<leader>cs',
                '<cmd>Trouble symbols toggle focus=false<cr>',
                desc = 'Symbols (Trouble)',
            },
            {
                '<leader>cl',
                '<cmd>Trouble lsp toggle focus=false win.position=right<cr>',
                desc = 'LSP Definitions / references / ... (Trouble)',
            },
            {
                '<leader>xL',
                '<cmd>Trouble loclist toggle<cr>',
                desc = 'Location List (Trouble)',
            },
            {
                '<leader>xQ',
                '<cmd>Trouble qflist toggle<cr>',
                desc = 'Quickfix List (Trouble)',
            },
        },
    },
}
