local function configure()
    return {
        repo = 'neovim/nvim-lspconfig',
        depends = {
            -- Not all of them are related to LSP but
            -- configure all the completion behavior here for easiness.
            'cmp',
            'cmp-lsp',
            'cmp-path',
            'cmp-buffer',
            'cmp-nvim-tags',
            'luasnip',
            'cmp-luasnip',
        },
        after_load = function()
            local lspconfig = require('lspconfig')

            -- Plugins to enable LSP auto-complation
            -- (https://github.com/neovim/nvim-lspconfig/wiki/Autocompletion)
            local luasnip = require('luasnip')
            local cmp = require('cmp')
            local cmp_nvim_lsp = require('cmp_nvim_lsp')

            local capabilities = cmp_nvim_lsp.default_capabilities()

            -- https://rust-analyzer.github.io/
            -- rustup component add rust-analyzer
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

            -- https://go.dev/gopls/
            -- go install golang.org/x/tools/gopls@latest
            lspconfig.gopls.setup({
                capabilities = capabilities,
            })

            -- https://github.com/typescript-language-server/typescript-language-server
            -- npm i -g typescript-language-server
            lspconfig.ts_ls.setup({
                capabilities = capabilities,
            })

            -- https://github.com/hrsh7th/vscode-langservers-extracted
            -- npm i -g vscode-langservers-extracted
            lspconfig.cssls.setup({
                capabilities = capabilities,
            })

            -- https://github.com/python-lsp/python-lsp-server
            lspconfig.pylsp.setup({
                capabilities = capabilities,
            })

            -- https://github.com/clangd/clangd
            lspconfig.clangd.setup({
                capabilities = capabilities,
            })

            -- https://docs.rubocop.org/rubocop/usage/lsp.html
            lspconfig.rubocop.setup({
                capabilities = capabilities,
            })

            -- Define key mappings.
            vim.api.nvim_create_autocmd('LspAttach', {
                group = 'vimrc',
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
                    vim.keymap.set('n', '<Space>vf', vim.lsp.buf.format, { buffer = event.buf })

                    vim.cmd([[
                        highlight VirtualTextError ctermfg=167 guifg=#e67e80 guibg=#543a48 gui=italic
                        highlight VirtualTextWarning ctermfg=214 guifg=#dbbc7f guibg=#4d4c43 gui=italic
                    ]])
                end,
            })

            -- Completion sources
            local cmp_lsp = {
                name = 'nvim_lsp'
            }
            local cmp_path = {
                name = 'path', -- File path completion
                option = {
                    get_cwd = function()
                        return vim.fn.getcwd()
                    end,
                },
                -- Unlike MUComplete, it fires only on "/" or "./".
                -- You can change the return value of `source._dirname` of `lua/cmp_path/init.lua` to improve this:
                -- - Before: `return nil`
                -- - After:  `return vim.fn.resolve(option.get_cwd(params))`
            }
            local cmp_buffer = {
                name = 'buffer', -- Keyword completion
                option = {
                    get_bufnrs = function()
                        return vim.api.nvim_list_bufs()
                    end,
                },
            }
            local cmp_tags = {
                name = 'tags', -- Ctags completion
            }

            -- Completion settings
            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                sources = cmp.config.sources(
                    -- Use LSP if possible and fallback to other completions.
                    { cmp_lsp },
                    { cmp_path },
                    { cmp_buffer }
                ),
                confirmation = {
                    get_commit_characters = function(_args)
                        return { '(', '.', ':' }
                    end,
                },
                mapping = {
                    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-d>'] = cmp.mapping.scroll_docs(4),

                    ['<C-n>'] = cmp.mapping(function()
                        if cmp.visible() then
                            cmp.select_next_item()
                        else
                            cmp.complete()
                        end
                    end, { 'i' }),
                    ['<C-p>'] = cmp.mapping(function()
                        if cmp.visible() then
                            cmp.select_prev_item()
                        else
                            cmp.complete()
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

                    -- Use the path completion based on the current buffer directory.
                    -- This is the default behavior of cmp-path but I configure cmp-path to
                    -- find paths based on cwd (see below) so added this to use buffer base path completion too.
                    ['<C-f><C-n>'] = cmp.mapping(function()
                        cmp.complete({
                            config = {
                                sources = {{ name = 'path' }},
                            },
                        })
                    end, { 'i' }),
                },
            })

            -- Customize completion sources for sopecific file types.
            cmp.setup.filetype('ruby', {
                sources = cmp.config.sources(
                    { cmp_path },
                    { cmp_tags, cmp_buffer }
                ),
            })
            cmp.setup.filetype('', {
                sources = {},
            })
            for _, ft in ipairs({ 'markdown', 'text' }) do
                cmp.setup.filetype(ft, {
                    sources = cmp.config.sources(
                        { cmp_path }
                    ),
                })
            end
        end,
    }
end

return { configure = configure }
