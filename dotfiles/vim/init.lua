local vim_dir = os.getenv("HOME") .. '/.vim'
vim.cmd('source ' .. vim_dir .. '/vimrc')

-- To use Neovim plugins, install by 'git clone' in 'pack/neovim/opt' manually for now.

local function packadd (name)
    vim.cmd('packadd ' .. name)
    local doc_dir = vim_dir .. '/pack/neovim/opt/' .. name .. '/doc'
    if vim.fn.isdirectory(doc_dir) == 1 then
        vim.cmd('helptags ' .. doc_dir)
    end
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
        highlight = { "IndentLine1", "IndentLine2" },
    },
})
