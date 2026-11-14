local function configure()
  return {
    repo = 'ryym/gitview.nvim',
    after_load = function()
        vim.keymap.set('n', '\\[git]o', ':<C-u>Gitview<CR>', { silent = true })

        vim.api.nvim_create_autocmd('FileType', {
            pattern = { 'gitview-files', 'gitview-commits', 'gitview-diff' },
            callback = function(event)
                local actions = require('gitview.actions')
                local opts = { buffer = event.buf, nowait = true }

                if event.match == 'gitview-diff' then
                    vim.opt_local.number = true
                    vim.opt_local.relativenumber = true
                    vim.keymap.set('n', '<Space>ba', actions.show_last_focused_diff, opts)
                end
            end,
        })
    end,
  }
end

return { configure = configure }
