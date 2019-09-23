function! my#plug#elm#configure(conf) abort
  let a:conf.repo = 'elmcast/elm-vim'
  let a:conf.async.detect_startup_file = ['elm']

  let g:elm_setup_keybindings = 0
endfunction
