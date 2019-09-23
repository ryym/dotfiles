function! my#plug#rust#configure(conf) abort
  let a:conf.repo = 'rust-lang/rust.vim'
  let a:conf.async.detect_startup_file = ['rs']
endfunction
