local function diffview_open()
    if vim.g.my_git_diff_base == nil then
        vim.cmd.DiffviewOpen()
    else
        vim.cmd.DiffviewOpen({ args = {vim.g.my_git_diff_base} })
    end
end

local function get_merge_base(branch)
    local result = vim.fn.system({'git', 'merge-base', branch, 'HEAD'})
    if vim.v.shell_error ~= 0 then
        vim.notify('Failed to get merge-base of ' .. branch .. ' and HEAD', vim.log.levels.ERROR)
        return nil
    end
    return vim.trim(result)
end

local function diffview_open_for_branch()
    vim.fn['fzf#run']({
        source = "git branch --format='%(refname:short)'",
        sink = function(branch)
            local merge_base = get_merge_base(branch)
            if merge_base == nil then
                return
            end
            vim.cmd('DiffviewOpen ' .. merge_base)
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
        vim.keymap.set('n', '\\[git]gd', diffview_open)
        vim.keymap.set('n', '\\[git]gb', diffview_open_for_branch)
        vim.keymap.set('n', '\\[git]gc', ':<C-u>DiffviewClose<CR>')
    end,
  }
end

return { configure = configure }
