function! my#plug#lightline#configure(conf) abort
  let a:conf.repo = 'itchyny/lightline.vim'
  let a:conf.after_load = function('my#plug#lightline#after_load')
endfunction

function! my#plug#lightline#after_load()
  if !has('vim_starting')
    call lightline#update() " Override default statusline when vimrc is reloaded.
  endif
endfunction
