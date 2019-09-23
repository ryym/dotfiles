function! my#plug#slim#configure(conf) abort
  let a:conf.repo = 'slim-template/vim-slim'
  let a:conf.async.detect_startup_file = ['slim']
endfunction
