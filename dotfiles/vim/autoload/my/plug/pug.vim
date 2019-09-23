function! my#plug#pug#configure(conf) abort
  let a:conf.repo = 'digitaltoad/vim-pug'
  let a:conf.async.detect_startup_file = ['pug']
endfunction
