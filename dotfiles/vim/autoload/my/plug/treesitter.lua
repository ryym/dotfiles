local function configure()
    return {
        repo = 'nvim-treesitter/nvim-treesitter',
        after_load = function()
            require('nvim-treesitter.configs').setup({
                ensure_installed = {
                    "css",
                    "go",
                    "javascript",
                    "html",
                    "lua",
                    "ruby",
                    "rust",
                    "tsx",
                    "typescript",
                },
                highlight = {
                    enable = true,
                    -- Disable them whose syntax highlight seems better than the treesitter's one.
                    disable = { "yaml" }
                },
            })

            -- Set the syntax option explicitly to make matchit ("%" jump on do/end) work.
            -- https://github.com/nvim-treesitter/nvim-treesitter/issues/584
            vim.api.nvim_create_autocmd({'BufNewFile', 'BufRead'}, {
                pattern = '*.rb',
                command = 'set syntax=ruby',
            })
        end,
    }
end

return { configure = configure }
