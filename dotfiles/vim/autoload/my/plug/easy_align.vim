function! my#plug#easy_align#configure(conf) abort
  let a:conf.repo = 'junegunn/vim-easy-align'
  let a:conf.after_load = function('my#plug#easy_align#after_load')
endfunction

function! my#plug#easy_align#after_load() abort
  Remap2 nx ga <Plug>(EasyAlign)
endfunction
