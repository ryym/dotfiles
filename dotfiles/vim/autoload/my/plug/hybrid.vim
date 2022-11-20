function! my#plug#hybrid#configure(conf) abort
  let a:conf.repo = 'w0ng/vim-hybrid'
  let a:conf.async.enabled = 0
  let a:conf.after_load = function('my#plug#hybrid#after_load')
endfunction

function! my#plug#hybrid#after_load() abort
  augroup vimrc
    autocmd ColorScheme hybrid highlight LineNr ctermfg=243 guifg=#676b41
    autocmd ColorScheme hybrid highlight Comment guifg=#707880 gui=none,italic
    autocmd ColorScheme hybrid highlight VertSplit ctermfg=60 guifg=#5f5b84
    autocmd ColorScheme hybrid highlight DiffText ctermfg=123 ctermbg=62

    " In Quickfix list CursorLine wins Search so text becomes hard to read
    " when a cursor on the Search-highlighted line in the default colorscheme.
    " This is why we change the Search highlight colors.
    autocmd ColorScheme hybrid highlight Search ctermfg=253 ctermbg=162
  augroup END

  colorscheme hybrid
endfunction
