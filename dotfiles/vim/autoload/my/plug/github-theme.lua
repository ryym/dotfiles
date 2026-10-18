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
                }
            },
        })
    end,
  }
end

return { configure = configure }
