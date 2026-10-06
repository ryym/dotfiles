local function configure()
  return {
    repo = 'hedyhli/outline.nvim',
    after_load = function()
        require("outline").setup({
            providers = {
                priority = { 'lsp', 'markdown', 'norg', 'man', 'treesitter' },
            },
        })
        vim.keymap.set('n', '<Space>oo', '<cmd>Outline<CR>')
    end,
  }
end

return { configure = configure }
