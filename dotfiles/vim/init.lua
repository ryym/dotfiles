local vim_dir = os.getenv("HOME") .. '/.vim'
vim.cmd('source ' .. vim_dir .. '/vimrc')

-- To use Neovim plugins, install by 'git clone' in 'pack/neovim/opt' manually for now.

-- Copied from pkcr.nvim to load plugins lazily.
-- https://github.com/lewis6991/pckr.nvim/blob/40c4193c83ef17a9cf38514b93a2332955789581/lua/pckr/util.lua
local function join_paths(...)
  return (table.concat({ ... }, '/'):gsub('//+', '/'))
end
local function ls(path, fn)
    local handle = vim.loop.fs_scandir(path)
    while handle do
        local name, t = vim.loop.fs_scandir_next(handle)
        if not name or not t then
            break
        end
        if fn(join_paths(path, name), name, t) == false then
            break
        end
    end
end
local function walk_dir(path, fn)
    ls(path, function(child, name, ftype)
        if ftype == 'directory' then
            walk_dir(child, fn)
        end
        fn(child, name, ftype)
    end)
end
local function source_runtime(dir)
  local vim_files, lua_files = {}, {}
  walk_dir(dir, function(path, name, t)
    local ext = name:sub(-3)
    name = name:sub(1, -5)
    if (t == "file" or t == "link") then
      if ext == "lua" then
        lua_files[#lua_files + 1] = path
      elseif ext == "vim" then
        vim_files[#vim_files + 1] = path
      end
    end
  end)
  for _, path in ipairs(vim_files) do
    vim.cmd.source(path)
  end
  for _, path in ipairs(lua_files) do
    vim.cmd.source(path)
  end
end

-- Load the package with handling of doc/ and after/ directories.
local function packadd (name)
    vim.cmd('packadd ' .. name)
    local pack_root = vim_dir .. '/pack/neovim/opt/' .. name
    local doc_dir = pack_root .. '/doc'
    if vim.fn.isdirectory(doc_dir) == 1 then
        vim.cmd('helptags ' .. doc_dir)
    end
    local after_plugin_dir = pack_root .. '/after/plugin'
    source_runtime(after_plugin_dir)
end

-- https://github.com/sainnhe/everforest
packadd('everforest')
vim.cmd([[
    let g:everforest_transparent_background = 1
    colorscheme everforest
    " Adjust statusline and tabline styles for everforest.
    let g:lightline = { 'colorscheme': 'one' }
    let g:lightline.enable = { 'statusline': 1, 'tabline': 0 }
    call lightline#init()

    hi Normal ctermfg=none guifg=none
    hi NormalNC ctermfg=none guifg=none
    hi Fg ctermfg=none guifg=none
]])

-- Load most plugins lazily to make Neovim launch faster.
vim.schedule(function ()
    -- https://github.com/nvim-treesitter/nvim-treesitter/
    packadd('nvim-treesitter')
    require('nvim-treesitter.configs').setup({
        ensure_installed = {
            "go",
            "javascript",
            "ruby",
            "rust",
            "tsx",
            "typescript",
        },
        highlight = {
            enable = true,
            disable = {
                -- TS does not highlight constants and symbols so make code less readable.
                "ruby",
            }
        },
    })

    -- https://github.com/lukas-reineke/indent-blankline.nvim
    packadd('indent-blankline')
    local hooks = require("ibl.hooks")
    hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        vim.api.nvim_set_hl(0, "IndentLine1", { fg = "#4f585e" })
        vim.api.nvim_set_hl(0, "IndentLine2", { fg = "#4e6878" })
    end)
    require('ibl').setup({
        indent = {
            char = '▏',
            tab_char = '▏',
            highlight = { "IndentLine1", "IndentLine2" },
        },
        scope = {
            show_start = false,
        }
    })

    -- https://github.com/uga-rosa/ccc.nvim
    packadd('ccc.nvim')
    require('ccc').setup({})

    -- https://github.com/neovim/nvim-lspconfig
    packadd('nvim-lspconfig')
    local lspconfig = require('lspconfig')

    lspconfig.rust_analyzer.setup({})
    lspconfig.tsserver.setup({})
    lspconfig.gopls.setup({})

    vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(event)
            vim.keymap.set('n', '<Space>vh', vim.lsp.buf.hover, { buffer = event.buf })
            vim.keymap.set('n', '<Space>vv', vim.lsp.buf.definition, { buffer = event.buf })
            vim.keymap.set('n', '<Space>vt', vim.lsp.buf.type_definition, { buffer = event.buf })
            vim.keymap.set('n', '<Space>vr', vim.lsp.buf.rename, { buffer = event.buf })
            vim.keymap.set('n', '<Space>vR', vim.lsp.buf.references, { buffer = event.buf })
            vim.keymap.set('n', '<Space>vs', vim.lsp.buf.signature_help, { buffer = event.buf })
            vim.keymap.set('n', '<Space>vI', vim.lsp.buf.implementation, { buffer = event.buf })
            vim.keymap.set('n', '<Space>vd', vim.diagnostic.open_float, { buffer = event.buf })

            vim.cmd([[
            hi VirtualTextError ctermfg=167 guifg=#e67e80 guibg=#543a48 gui=italic
            hi VirtualTextWarning ctermfg=214 guifg=#dbbc7f guibg=#4d4c43 gui=italic
            ]])
        end,
    })

    -- Enable LSP autocompletion. (https://github.com/neovim/nvim-lspconfig/wiki/Autocompletion)
    packadd('nvim-cmp')
    packadd('cmp-nvim-lsp')
    packadd('LuaSnip')
    packadd('cmp_luasnip')

    local capabilities = require("cmp_nvim_lsp").default_capabilities()
    for _, lsp in ipairs({ 'rust_analyzer', 'tsserver' }) do
        lspconfig[lsp].setup {
            capabilities = capabilities,
        }
    end

    local luasnip = require('luasnip')
    local cmp = require('cmp')
    cmp.setup({
        snippet = {
            expand = function(args)
                luasnip.lsp_expand(args.body)
            end,
        },
        sources = cmp.config.sources({
            { name = 'nvim_lsp' },
            { name = 'luasnip' },
        }),
        mapping = {
            ['<C-u>'] = cmp.mapping.scroll_docs(-4),
            ['<C-d>'] = cmp.mapping.scroll_docs(4),

            -- Use fallback() for <C-n> and <C-p> to use ins-completion when LSP is not enabled.
            ['<C-n>'] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_next_item()
                else
                    fallback()
                end
            end, { 'i', 's' }),
            ['<C-p>'] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item()
                else
                    fallback()
                end
            end, { 'i', 's' }),

            ['<Tab>'] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.confirm({ select = true })
                elseif luasnip.expand_or_jumpable() then
                    luasnip.expand_or_jump()
                else
                    fallback()
                end
            end, { 'i', 's' }),
        },
    })
end)
