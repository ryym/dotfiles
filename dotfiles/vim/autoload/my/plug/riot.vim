function! my#plug#riot#configure(conf) abort
  let a:conf.repo = 'ryym/vim-riot'
  let a:conf.async.detect_startup_file = ['riot', 'tag']
endfunction
