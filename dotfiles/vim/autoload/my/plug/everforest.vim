function! my#plug#everforest#configure(conf) abort
  let a:conf.repo = 'sainnhe/everforest'
  let a:conf.async.enabled = 0
  let a:conf.after_load = function('my#plug#everforest#after_load')

  if !has('nvim')
    let a:conf.depends = ['lightline']
  endif

  " Use different theme in Vim and Neovim to easily distinguish wether I am using.
  let a:conf.skip_load = !has('nvim')
endfunction

function! my#plug#everforest#after_load()
  let g:everforest_transparent_background = 1

  augroup vimrc!
    autocmd! ColorScheme everforest call s:tweak_highlight()
  augroup END

  colorscheme everforest

  if !has('nvim')
    " Adjust statusline and tabline styles for everforest.
    let g:lightline.enable = { 'statusline': 1, 'tabline': 0 }
    call lightline#init()
  endif
endfunction

function! s:tweak_highlight()
  " Make text colors transparent so that it is inherited from the terminal settings.
  highlight Normal ctermfg=NONE guifg=NONE
  highlight NormalNC ctermfg=NONE guifg=NONE
  highlight Fg ctermfg=NONE guifg=NONE

  highlight DiffText guifg=NONE guibg=#4e6d80
endfunction
