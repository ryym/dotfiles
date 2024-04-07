local function configure()
    -- Used in lspconfig.lua
    return {
        repo = 'hrsh7th/cmp-nvim-lsp',
        depends = {'cmp'},
    }
end

return { configure = configure }
