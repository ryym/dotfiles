local function configure()
    return {
        repo = 'lewis6991/gitsigns.nvim',
        after_load = function()
            local gitsigns = require('gitsigns')
            gitsigns.setup {
                signs_staged_enable = true,
                signcolumn = true,
                numhl      = true,
                linehl     = false,
                word_diff  = true,

                on_attach = function(bufnr)
                    local function map(mode, l, r, opts)
                        opts = opts or {}
                        opts.buffer = bufnr
                        vim.keymap.set(mode, l, r, opts)
                    end

                    local nav_hunk = function(key, direction)
                        return function()
                            if vim.wo.diff then
                                vim.cmd.normal({key, bang = true})
                            else
                                gitsigns.nav_hunk(direction)
                            end
                        end
                    end

                    vim.keymap.set('n', '[c', nav_hunk('[c', 'prev'), { buffer = bufnr })
                    vim.keymap.set('n', ']c', nav_hunk(']c', 'next'), { buffer = bufnr })

                    vim.keymap.set('n', '\\[git]d', gitsigns.toggle_deleted)
                    vim.keymap.set('n', '\\[git]d', gitsigns.diffthis)
                    vim.keymap.set('n', '\\[git]h', function()
                        gitsigns.toggle_linehl()
                        gitsigns.toggle_deleted()
                    end)

                    vim.keymap.set('n', '\\[git]b', function()
                        gitsigns.blame({ ignore_whitespace = true })
                    end)
                    vim.keymap.set('n', '\\[git]ib', gitsigns.toggle_current_line_blame)

                    map('n', '\\[git]$c', function()
                        vim.ui.input({ prompt = 'Change base to: ' }, function(base)
                            if base ~= nil and base ~= '' then
                                gitsigns.change_base(base, true, function(err)
                                    if not err then
                                        vim.g.my_git_diff_base = base
                                    end
                                end)
                            end
                        end)
                    end)
                end,
            }

            vim.api.nvim_create_autocmd('FileType', {
                pattern = 'gitsigns-blame',
                callback = function(args)
                    -- Open a PR page which contains a commit your cursor put on.
                    vim.keymap.set('n', 'P', function()
                        vim.fn.system('whichpr ' .. vim.fn.expand('<cword>'))
                    end, { buffer = args.buf })
                end,
            })
        end,
    }
end

return { configure = configure }
