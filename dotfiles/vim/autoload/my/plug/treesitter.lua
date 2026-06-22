local function configure()
    -- The `main` branch dropped `nvim-treesitter.configs` and requires Neovim 0.12+,
    -- while older Neovim must stay on the legacy `master` branch.
    local branch = vim.fn.has('nvim-0.12') == 1 and 'main' or 'master'

    return {
        repo = 'nvim-treesitter/nvim-treesitter',
        branch = vim.fn.has('nvim-0.12') == 1 and 'main' or 'master',
        after_load = function()
            local parsers = {
                "css",
                "go",
                "javascript",
                "html",
                "lua",
                "ruby",
                "rust",
                "tsx",
                "typescript",
                "markdown",
                "markdown_inline",
                "python",
                "json",
                "sql",
            }
            -- Install parsers. The `nvim-treesitter.configs` module exists only on
            -- the legacy `master` branch. The new `main` branch (Neovim 0.12+) dropped it.
            local ok, configs = pcall(require, 'nvim-treesitter.configs')
            if ok then
                configs.setup({ ensure_installed = parsers })
            else
                require('nvim-treesitter').install(parsers)
            end

            vim.api.nvim_create_autocmd('FileType', {
                group = 'vimrc',
                callback = function(args)
                    -- Disable them whose syntax highlight seems better than the treesitter's one.
                    if args.match == 'yaml' then
                        return
                    end
                    -- No-op when no parser is installed for the filetype.
                    pcall(vim.treesitter.start)
                end,
            })

            -- Set the syntax option explicitly to make matchit ("%" jump on do/end) work.
            -- https://github.com/nvim-treesitter/nvim-treesitter/issues/584
            vim.api.nvim_create_autocmd({'BufNewFile', 'BufRead'}, {
                group = 'vimrc',
                pattern = '*.rb',
                command = 'set syntax=ruby',
            })

            vim.opt.foldmethod = 'expr'
            vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
            vim.opt.foldlevel = 99
            vim.opt.foldlevelstart = 99
        end,
    }
end

return { configure = configure }
