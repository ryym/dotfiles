local function configure()
    -- Used in lspconfig.lua
    return {
        repo = 'saadparwaiz1/cmp_luasnip',
        depends = {'cmp'},
    }
end

return { configure = configure }
