local function configure()
    return {
        repo = 'nvim-lualine/lualine.nvim',
        after_load = function()
            -- https://github.com/nvim-lualine/lualine.nvim
            require('lualine').setup {
                options = {
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
                    lualine_b = {'branch', 'diff', 'diagnostics'},
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
