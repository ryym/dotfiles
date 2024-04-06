function! my#init#plugins#setup() abort
  " Skip loading plugins if this environment variable exists.
  if $VIM_NO_PLUG
    return
  endif

  " https://github.com/ryym/vim-plugger
  call my#init#func#iniplug#load('vim-plugger')

  packadd! matchit

  call plugger#enable({
    \   'conf_root': $MYVIMDIR . '/autoload/my/plug/',
    \   'autoload_prefix': 'my#plug#',
    \ })
endfunction
