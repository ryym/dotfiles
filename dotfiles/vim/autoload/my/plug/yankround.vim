function! my#plug#yankround#configure(conf) abort
  let a:conf.repo = 'LeafCage/yankround.vim'
  let a:conf.after_load = function('my#plug#yankround#after_load')
endfunction

function! my#plug#yankround#after_load()
  Remap nx p     <Plug>(yankround-p)
  Remap n  P     <Plug>(yankround-P)
  Remap nx gp    <Plug>(yankround-gp)
  Remap n  gP    <Plug>(yankround-gP)
  Remap n <C-p> <Plug>(yankround-prev)
  Remap n <C-n> <Plug>(yankround-next)
endfunction
