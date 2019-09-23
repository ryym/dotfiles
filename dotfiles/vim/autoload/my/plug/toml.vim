function! my#plug#toml#configure(conf) abort
  let a:conf.repo = 'cespare/vim-toml'
  let a:conf.async.detect_startup_file = ['toml']
endfunction
