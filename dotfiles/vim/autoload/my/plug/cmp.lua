local function configure()
    return {
        repo = 'hrsh7th/nvim-cmp',
        -- All completion configurations are defined in `lspconfig.lua`
        -- because LSP configs involve completion settings.
    }
end

return { configure = configure }
