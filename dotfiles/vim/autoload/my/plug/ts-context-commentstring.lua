local function configure()
    return {
        repo = 'JoosepAlviste/nvim-ts-context-commentstring',
        after_load = function()
            require('ts_context_commentstring').setup({
                languages = {
                    css = '/* %s */',
                    ruby = '# %s',
                    rust = '// %s',
                },
            })
        end,
    }
end

return { configure = configure }
