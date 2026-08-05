local function configure()
  return {
      repo = 'lewis6991/gitsigns.nvim',
      after_load = function()
          require('gitsigns').setup {
              signs_staged_enable = true,
              signcolumn = true,
              numhl      = true,
              linehl     = true,
              word_diff  = true,
          }
      end,
  }
end

return { configure = configure }
