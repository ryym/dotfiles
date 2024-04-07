function! my#init#plugins#setup() abort
  " Skip loading plugins if this environment variable exists.
  if $VIM_NO_PLUG
    return
  endif

  " https://github.com/ryym/vim-plugger
  call my#init#func#iniplug#load('vim-plugger')

  packadd! matchit

  if has('nvim')
    lua package.path = package.path .. ';' .. os.getenv('MYVIMDIR') .. '/autoload/?.lua'
  endif

  call plugger#enable({
    \   'conf_root': $MYVIMDIR . '/autoload/my/plug/',
    \   'autoload_prefix': 'my#plug#',
    \   'lua_require_prefix': 'my.plug.',
    \ })
endfunction
