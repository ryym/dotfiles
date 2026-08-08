function! my#plug#yankround#configure(conf) abort
  let a:conf.repo = 'LeafCage/yankround.vim'
  let a:conf.after_load = function('my#plug#yankround#after_load')
endfunction

function! my#plug#yankround#after_load()
  Remap2 nx p     <Plug>(yankround-p)
  Remap2 n  P     <Plug>(yankround-P)
  Remap2 nx gp    <Plug>(yankround-gp)
  Remap2 n  gP    <Plug>(yankround-gP)
  Remap2 n <C-p> <Plug>(yankround-prev)
  Remap2 n <C-n> <Plug>(yankround-next)
endfunction
