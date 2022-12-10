function! my#plug#json5#configure(conf) abort
  let a:conf.repo = 'gutenye/json5.vim'
  let a:conf.async.detect_startup_file = ['json']
endfunction
