local function configure()
  return {
    repo = 'projekt0n/github-nvim-theme',
    after_load = function()
        require('github-theme').setup({
            options = {
                styles = {
                    comments = 'italic',
                },
            },
            groups = {
                all = {
                    Added = { fg = 'NONE' },
                },
                github_dark_dimmed = {
                    NormalFloat = { bg = '#313842' },

                    -- Markdown heading styles
                    ['@markup.heading.1.markdown'] = { fg = 'palette.cyan.base',      style = 'bold' },
                    ['@markup.heading.2.markdown'] = { fg = 'palette.blue.bright',    style = 'bold' },
                    ['@markup.heading.3.markdown'] = { fg = 'palette.blue.base',      style = 'bold' },
                    ['@markup.heading.4.markdown'] = { fg = 'palette.magenta.bright', style = 'bold' },
                    ['@markup.heading.5.markdown'] = { fg = 'palette.magenta.base',   style = 'bold' },
                    ['@markup.heading.6.markdown'] = { fg = 'palette.fg.default',     style = 'bold' },
                }
            },
        })
    end,
  }
end

return { configure = configure }
