local function configure()
    return {
        repo = 'quangnguyen30192/cmp-nvim-tags',
        depends = {'cmp'},
        -- All completion configurations are defined in `lspconfig.lua`
        -- because LSP configs involve completion settings.
    }
end

return { configure = configure }
