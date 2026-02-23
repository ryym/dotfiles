local function configure()
    return {
        repo = 'saadparwaiz1/cmp_luasnip',
        depends = {'cmp'},
        -- All completion configurations are defined in `lspconfig.lua`
        -- because LSP configs involve completion settings.
    }
end

return { configure = configure }
