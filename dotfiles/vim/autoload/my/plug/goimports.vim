function! my#plug#goimports#configure(conf) abort
  let a:conf.repo = 'mattn/vim-goimports'
  let a:conf.async.detect_startup_file = ['go']
  let a:conf.skip_load = 1 " Now we have LSP.
endfunction
