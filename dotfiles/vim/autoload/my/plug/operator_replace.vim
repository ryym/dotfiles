function! my#plug#operator_replace#configure(conf) abort
  let a:conf.repo = 'kana/vim-operator-replace'
  let a:conf.depends = ['operator_user']
  let a:conf.after_load = function('my#plug#operator_replace#after_load')
endfunction

function! my#plug#operator_replace#after_load()
  Remap nvo mr <Plug>(operator-replace)
endfunction

