local function buffer_relative_path()
    local abs_path = vim.fn['my#init#func#buf#abs_path']('%')
    return vim.fn.fnamemodify(abs_path, ':.')
end

local function everforest_theme()
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
            c = {bg = palette.bg2[1], fg = palette.grey2[1]},
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
        inactive = {
            c = {bg = palette.bg1[1], fg = palette.grey2[1]},
        },
    }
end

local function github_dark_dimmed_theme()
    -- The github_dark_dimmed theme with small tweaks.
    -- Note that github-nvim-theme has builtin support for lualine.
    -- To use that, just return a theme name 'github_dark_dimmed'.
    local spec = require('github-theme.spec').load('github_dark_dimmed')
    local palette = spec.palette
    local function mode_color(color)
        return {bg = color, fg = spec.bg1, gui = 'bold'}
    end
    return {
        normal = {
            a = mode_color(palette.blue.base),
            b = {bg = palette.scale.gray[6], fg = spec.fg1},
            c = {bg = palette.scale.gray[8], fg = spec.fg1},
        },
        insert = {a = mode_color(palette.green.base)},
        visual = {a = mode_color(palette.yellow.base)},
        replace = {a = mode_color(palette.red.base)},
        command = {a = mode_color(palette.magenta.bright)},
        terminal = {a = mode_color(palette.orange)},
        inactive = {
            c = {bg = spec.bg1, fg = spec.fg2},
        },
    }
end

local themes = {
    everforest = everforest_theme,
    github_dark_dimmed = github_dark_dimmed_theme,
}

local function current_theme()
    local theme = themes[vim.g.colors_name] or everforest_theme
    return theme()
end

local function configure()
    filename_opt_with_parent_dir = 4

    return {
        repo = 'nvim-lualine/lualine.nvim',
        async = { enabled = 0 },
        after_load = function()
            -- https://github.com/nvim-lualine/lualine.nvim
            require('lualine').setup {
                options = {
                    theme = current_theme,
                    component_separators = { left = '|', right = '|'},
                    section_separators = { left = '', right = ''},
                    globalstatus = true,
                    disabled_filetypes = {
                        winbar = {
                            'terminal',
                            'qf',
                            'fzf',
                            'viler',
                            'gitview-files',
                            'gitview-commits',
                            'gitview-diff',
                        },
                    },
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
                        buffer_relative_path,
                    },
                    lualine_x = {'encoding', 'fileformat', 'filetype'},
                    -- progress percentage and total line
                    lualine_y = {'%p%% / %LL'},
                    -- current line and column
                    lualine_z = {'%l:%c'},
                },
                winbar = {
                    lualine_c = {
                        {'filename', path = filename_opt_with_parent_dir},
                    },
                },
                inactive_winbar = {
                    lualine_c = {
                        {'filename', path = filename_opt_with_parent_dir},
                    },
                },
            }
        end,
    }
end

return { configure = configure }
