function! my#plug#jsx#configure(conf) abort
  let a:conf.repo = 'mxw/vim-jsx'
  let a:conf.async.detect_startup_file = ['js']

  let g:jsx_ext_required = 0
endfunction
