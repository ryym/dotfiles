function! my#plug#hybrid#configure(conf) abort
  let a:conf.repo = 'w0ng/vim-hybrid'

  function a:conf.after_load()
    colorscheme hybrid
  endfunction
endfunction
