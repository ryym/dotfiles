function! my#plug#ps1#configure(conf) abort
  let a:conf.repo = 'PProvost/vim-ps1'
  let a:conf.async.detect_startup_file = ['ps1']
endfunction
