function! my#init#colorscheme#setup() abort
  if has('vim_starting')
    set t_Co =256
    if &t_Co < 256
      colorscheme desert
    else
      colorscheme smyck256
    endif
  endif
endfunction
