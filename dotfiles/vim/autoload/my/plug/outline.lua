local function configure()
  return {
    repo = 'hedyhli/outline.nvim',
    after_load = function()
        require("outline").setup()
        vim.keymap.set('n', '<Space>oo', '<cmd>Outline<CR>')
    end,
  }
end

return { configure = configure }
