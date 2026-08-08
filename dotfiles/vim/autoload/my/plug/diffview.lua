local function configure()
  return {
    repo = 'sindrets/diffview.nvim',
    after_load = function()
        require("diffview").setup({
            enhanced_diff_hl = true,
        })
        vim.keymap.set('n', '\\[git]gd', ':<C-u>DiffviewOpen<CR>')
        vim.keymap.set('n', '\\[git]gc', ':<C-u>DiffviewClose<CR>')
    end,
  }
end

return { configure = configure }
