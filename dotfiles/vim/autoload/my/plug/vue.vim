function! my#plug#vue#configure(conf) abort
  let a:conf.repo = 'posva/vim-vue'
  let a:conf.async.detect_startup_file = ['vue']
endfunction
