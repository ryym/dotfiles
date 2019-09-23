function! my#plug#hug_neovim_rpc#configure(conf) abort
  let a:conf.repo = 'roxma/vim-hug-neovim-rpc'
  let a:conf.install_if = !has('nvim')
endfunction
