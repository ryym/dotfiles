local function configure()
    return {
        repo = 'neovim/nvim-lspconfig',
        depends = {'cmp', 'cmp-lsp', 'luasnip', 'cmp-luasnip'},
        after_load = function()
            local lspconfig = require('lspconfig')

            -- Plugins to enable LSP auto-complation
            -- (https://github.com/neovim/nvim-lspconfig/wiki/Autocompletion)
            local luasnip = require('luasnip')
            local cmp = require('cmp')
            local cmp_nvim_lsp = require('cmp_nvim_lsp')

            local capabilities = cmp_nvim_lsp.default_capabilities()

            -- Set up language servers.
            lspconfig.rust_analyzer.setup({
                capabilities = capabilities,
                settings = {
                    ['rust-analyzer'] = {
                        cargo = {
                            features = 'all',
                        },
                    },
                },
            })
            lspconfig.tsserver.setup({
                capabilities = capabilities,
            })
            lspconfig.gopls.setup({
                capabilities = capabilities,
            })
            lspconfig.cssls.setup({
                capabilities = capabilities,
            })

            -- Define key mappings.
            vim.api.nvim_create_autocmd('LspAttach', {
                callback = function(event)
                    vim.keymap.set('n', '<Space>vh', vim.lsp.buf.hover, { buffer = event.buf })
                    vim.keymap.set('n', '<Space>vv', vim.lsp.buf.definition, { buffer = event.buf })
                    vim.keymap.set('n', '<Space>vt', vim.lsp.buf.type_definition, { buffer = event.buf })
                    vim.keymap.set('n', '<Space>vr', vim.lsp.buf.rename, { buffer = event.buf })
                    vim.keymap.set('n', '<Space>vR', vim.lsp.buf.references, { buffer = event.buf })
                    vim.keymap.set('n', '<Space>vs', vim.lsp.buf.signature_help, { buffer = event.buf })
                    vim.keymap.set('n', '<Space>vI', vim.lsp.buf.implementation, { buffer = event.buf })
                    vim.keymap.set('n', '<Space>vd', vim.diagnostic.open_float, { buffer = event.buf })
                    vim.keymap.set('n', '<Space>vD', vim.diagnostic.setqflist, { buffer = event.buf })

                    vim.cmd([[
                        highlight VirtualTextError ctermfg=167 guifg=#e67e80 guibg=#543a48 gui=italic
                        highlight VirtualTextWarning ctermfg=214 guifg=#dbbc7f guibg=#4d4c43 gui=italic
                    ]])
                end,
            })

            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                sources = cmp.config.sources({
                    { name = 'nvim_lsp' },
                }),
                confirmation = {
                    get_commit_characters = function(_args)
                        return { '(', '.', ':' }
                    end,
                },
                mapping = {
                    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-d>'] = cmp.mapping.scroll_docs(4),

                    -- Use fallback() for <C-n> and <C-p> to use ins-completion when LSP is not enabled.
                    ['<C-n>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        else
                            fallback()
                        end
                    end, { 'i' }),
                    ['<C-p>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        else
                            fallback()
                        end
                    end, { 'i' }),

                    ['<Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.confirm({ select = true })
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                },
            })
        end,
    }
end

return { configure = configure }
