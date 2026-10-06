local function configure()
  return {
    repo = 'epheien/outline-treesitter-provider.nvim',
    depends = {'outline', 'treesitter'},
  }
end

return { configure = configure }
