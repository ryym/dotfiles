function! my#plug#scala#configure(conf) abort
  let a:conf.repo = 'derekwyatt/vim-scala'
  let a:conf.async.detect_startup_file = ['scala']
endfunction
