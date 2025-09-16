local function configure()
    return {
        repo = 'nvim-treesitter/nvim-treesitter-context',
        after_load = function()
            require('treesitter-context').setup({
                enable = false, -- Enable only when I want.
                mode = 'topline',
            })
            vim.keymap.set('n', 'coH', ':TSContext toggle<CR>')
        end,
    }
end

return { configure = configure }
