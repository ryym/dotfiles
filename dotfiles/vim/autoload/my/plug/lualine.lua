local function configure()
    return {
        repo = 'nvim-lualine/lualine.nvim',
        async = { enabled = 0 },
        after_load = function()
            local everforest = (function()
                -- The everforest theme with small tweaks.
                --   - Use a different background color for "c" than the cursor line.
                --   - Keep the same text color regardless of the Vim mode.
                -- https://github.com/sainnhe/everforest/blob/28d59e29d/lua/lualine/themes/everforest.lua
                local configuration = vim.fn['everforest#get_configuration']()
                local palette = vim.fn['everforest#get_palette'](
                    configuration.background,
                    configuration.colors_override
                )
                return {
                    normal = {
                        a = {bg = palette.statusline1[1], fg = palette.bg0[1], gui = 'bold'},
                        b = {bg = palette.bg4[1], fg = palette.grey2[1]},
                        c = {bg = palette.bg2[1], fg = palette.grey2[1]}
                    },
                    insert = {
                        a = {bg = palette.statusline2[1], fg = palette.bg0[1], gui = 'bold'},
                    },
                    visual = {
                        a = {bg = palette.statusline3[1], fg = palette.bg0[1], gui = 'bold'},
                    },
                    replace = {
                        a = {bg = palette.orange[1], fg = palette.bg0[1], gui = 'bold'},
                    },
                    command = {
                        a = {bg = palette.aqua[1], fg = palette.bg0[1], gui = 'bold'},
                    },
                    terminal = {
                        a = {bg = palette.purple[1], fg = palette.bg0[1], gui = 'bold'},
                    },
                }
            end)()

            -- https://github.com/nvim-lualine/lualine.nvim
            require('lualine').setup {
                options = {
                    theme = everforest,
                    component_separators = { left = '|', right = '|'},
                    section_separators = { left = '', right = ''},
                    globalstatus = true,
                },
                sections = {
                    lualine_a = {
                        {
                            'mode',
                            fmt = function(name)
                                return name:sub(1, 1)
                            end,
                        }
                    },
                    lualine_b = {
                        {'diff', icon = ''},
                        'diagnostics',
                    },
                    lualine_c = {
                        {
                            'filename',
                            path = 1, -- relative path
                        },
                    },
                    lualine_x = {'encoding', 'fileformat', 'filetype'},
                    lualine_y = {'progress'},
                    lualine_z = {'location'},
                },
                -- winbar = {
                --     lualine_c = {'filename'}
                -- },
                -- inactive_winbar = {
                --     lualine_c = {'filename'}
                -- },
            }
        end,
    }
end

return { configure = configure }
