local function diffview_open_for_branch()
    vim.fn['fzf#run']({
        source = "git branch --format='%(refname:short)'",
        sink = function(branch)
            vim.cmd('DiffviewOpen ' .. branch)
        end,
        up = '45%',
        options = '--header "[base branch for diff]"',
    })
end


local function configure()
  return {
    repo = 'sindrets/diffview.nvim',
    after_load = function()
        require("diffview").setup({
            enhanced_diff_hl = true,
        })
        vim.keymap.set('n', '\\[git]gd', ':<C-u>DiffviewOpen<CR>')
        vim.keymap.set('n', '\\[git]gc', ':<C-u>DiffviewClose<CR>')
        vim.keymap.set('n', '\\[git]gb', diffview_open_for_branch)
    end,
  }
end

return { configure = configure }
