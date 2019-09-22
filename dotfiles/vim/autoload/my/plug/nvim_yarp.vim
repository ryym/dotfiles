function! my#plug#nvim_yarp#configure(conf) abort
  let a:conf.repo = 'roxma/nvim-yarp'
  let a:conf.install_if = !has('nvim')
endfunction
