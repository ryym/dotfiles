function! my#plug#cursorword#configure(conf) abort
  let a:conf.repo = 'itchyny/vim-cursorword'
  let a:conf.after_load = function('my#plug#cursorword#after_load')
endfunction

function! my#plug#cursorword#after_load()
  augroup vim-cursorword
    autocmd!
    autocmd FileType defx let b:cursorword = 0
  augroup END
endfunction
