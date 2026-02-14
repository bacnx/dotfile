return {
    {
        'neovim/nvim-lspconfig',
        keys = {
            {
                'gI',
                require('telescope.builtin').lsp_implementations,
                desc = 'Goto implementation',
            },
            {
                'gD',
                require('telescope.builtin').lsp_definitions,
                desc = 'Goto definition',
            },
        },
        config = function(_, opts)
            local capabilities = require('cmp_nvim_lsp').default_capabilities()

            for lsp, config in pairs(opts.servers) do
                local lsp_config = vim.tbl_deep_extend('force', { capabilities = capabilities }, config)
                vim.lsp.enable(lsp)
                vim.lsp.config(lsp, lsp_config)
            end
        end,
        opts = {
            servers = {
                lua_ls = {
                    settings = {
                        Lua = {
                            diagnostics = {
                                globals = { 'vim' },
                            },
                        },
                    },
                },
                clangd = {
                    filetypes = { 'c', 'objc', 'cpp', 'objcpp' },
                },
                ts_ls = {},
                gopls = {
                    -- cmd = { 'gopls' },
                    -- filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
                    -- root_dir = require('lspconfig.util').root_pattern('go.work', 'gomod', '.git'),
                    -- settings = {
                    --     gopls = {
                    --         completeUnimported = true,
                    --         semanticTokens = true,
                    --         analyses = {
                    --             unusedparams = true,
                    --         },
                    --     },
                    -- },
                },
                cssls = {},
                emmet_ls = {},
                tailwindcss = {},
                protols = {},
                jsonls = {},
                dockerls = {},
                docker_compose_language_service = {},
                zls = {},
            },
        },
    },
}
