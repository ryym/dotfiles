function! my#plug#rasi#configure(conf) abort
  let a:conf.repo = 'Fymyte/rasi.vim'
  let a:conf.async.detect_startup_file = ['rasi']
endfunction
