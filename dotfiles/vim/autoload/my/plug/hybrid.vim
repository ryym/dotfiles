function! my#plug#hybrid#configure(conf) abort
  let a:conf.repo = 'w0ng/vim-hybrid'
  let a:conf.async.enabled = 0

  function a:conf.after_load()
    colorscheme hybrid
  endfunction
endfunction
