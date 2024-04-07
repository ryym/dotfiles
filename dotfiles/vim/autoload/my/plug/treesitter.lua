local function configure()
    return {
        repo = 'nvim-treesitter/nvim-treesitter',
        after_load = function()
            require('nvim-treesitter.configs').setup({
                ensure_installed = {
                    "go",
                    "javascript",
                    "lua",
                    "ruby",
                    "rust",
                    "tsx",
                    "typescript",
                },
                highlight = {
                    enable = true,
                    -- Disable them whose syntax highlight seems better than the treesitter's one.
                    disable = { "ruby", "yaml" }
                },
            })
        end,
    }
end

return { configure = configure }
