return {
    {
        -- TODO: improve with treesitter
        'windwp/nvim-autopairs',
        event = 'InsertEnter',
        config = true,
    },
    -- Auto adjust shiftwidth and expandtab
    { 'tpope/vim-sleuth' },
    {
        'JoosepAlviste/nvim-ts-context-commentstring',
        config = function()
            require('ts_context_commentstring').setup({
                enable = true,
                enable_autocmd = false,
            })

            local get_option = vim.filetype.get_option
            vim.filetype.get_option = function(filetype, option)
                return option == 'commentstring'
                        and require('ts_context_commentstring.internal').calculate_commentstring()
                    or get_option(filetype, option)
            end
        end,
    },
    {
        'hrsh7th/nvim-cmp',
        event = 'InsertEnter',
        dependencies = {
            'neovim/nvim-lspconfig',
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-cmdline',
            'L3MON4D3/LuaSnip',
            'saadparwaiz1/cmp_luasnip',
        },
        opts = function()
            local cmp = require('cmp')
            local luasnip = require('luasnip')
            return {
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-d>'] = cmp.mapping.scroll_docs(4),
                    ['<C-k>'] = cmp.mapping.select_prev_item(),
                    ['<C-j>'] = cmp.mapping.select_next_item(),
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<C-e>'] = cmp.mapping.abort(),
                    ['<CR>'] = cmp.mapping.confirm({ select = true }),
                }),
                sources = require('cmp').config.sources({
                    { name = 'nvim_lsp' },
                    { name = 'buffer' },
                }, {
                    { name = 'buffer' },
                }),
            }
        end,
    },
    {
        'nvimdev/lspsaga.nvim',
        lazy = false,
        dependencies = {
            'nvim-treesitter/nvim-treesitter',
            'nvim-tree/nvim-web-devicons',
        },
        opts = {
            code_action = {
                extend_gitsigns = true,
            },
            definition = {
                width = 0.8,
                height = 0.7,
            },
            ui = {
                code_action = '',
            },
            symbol_in_winbar = {
                enable = false,
            },
        },
        keys = {
            { 'K', '<CMD>Lspsaga hover_doc<CR>' },
            { '[d', '<CMD>Lspsaga diagnostic_jump_prev<CR>' },
            { ']d', '<CMD>Lspsaga diagnostic_jump_next<CR>' },
            { 'gd', '<CMD>Lspsaga peek_definition<CR>', desc = 'Goto definition' },
        },
    },
}
