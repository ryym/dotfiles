local function configure()
    return {
        repo = 'lukas-reineke/indent-blankline.nvim',
        depends = {'treesitter'},
        after_load = function()
            local hooks = require("ibl.hooks")
            hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
                vim.api.nvim_set_hl(0, 'IndentLine1', { fg = '#4f585e' })
                vim.api.nvim_set_hl(0, 'IndentLine2', { fg = '#4e6878' })
            end)
            require('ibl').setup({
                indent = {
                    char = '▏',
                    highlight = { 'IndentLine1', 'IndentLine2' },
                },
                scope = {
                    show_start = false,
                    show_end = false,
                }
            })
        end,
    }
end

return { configure = configure }
