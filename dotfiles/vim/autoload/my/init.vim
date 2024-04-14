function! my#init#setup() abort
  " Global utility constants.
  let g:is_windows = has('win32') || has('win64')
  let g:is_mac = has('mac') || has('macunix') || has('gui_macvim')
  let g:is_unix = !has('mac') && has('unix')
  let g:is_gui = has('gui_running')

  if has('nvim')
    let $MYVIMDIR = stdpath('config')
  else
    let $MYVIMDIR = expand(g:is_windows ? '~/vimfiles' : '~/.vim')
  endif
  let $VIMLOCAL = expand($MYVIMDIR . '/local')

  " Let's define auto commands under this 'vimrc' group so that
  " we can reset all of them here to avoid defining duplicate commands
  " when reloading vimrc.
  augroup vimrc
    autocmd!
  augroup END

  if has('vim_starting')
    autocmd vimrc VimEnter * call <SID>display_startup_time()

    let g:startuptime = reltime()
    function! s:display_startup_time()
      echomsg 'Startup time:' reltimestr(reltime(g:startuptime))
    endfunction
  endif

  if has('vim_starting')
    " Change the cursor to vertical bar in normal mode on the terminal.
    " (https://qiita.com/Linda_pp/items/9e0c94eb82b18071db34)
    let &t_SI .= "\e[6 q"
    let &t_EI .= "\e[2 q"
  endif
endfunction
