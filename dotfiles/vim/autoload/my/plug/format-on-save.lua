local function configure()
    return {
        repo = 'elentok/format-on-save.nvim',
        after_load = function()
            local format_on_save = require('format-on-save')
            local formatters = require('format-on-save.formatters')
            format_on_save.setup({
                formatter_by_ft = {
                    ruby = formatters.shell({
                        -- https://github.com/ryym/rbfmt
                        cmd = { 'rbfmt', '-' },
                    }),
                    -- typescript = formatters.shell({
                    --     cmd = { 'npx', 'prettier', '--stdin-filepath', '%' },
                    -- }),
                },
                auto_commands = false,
            })
        end,
    }
end

return { configure = configure }

