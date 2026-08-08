function! my#plug#operator_camelize#configure(conf) abort
  let a:conf.repo = 'ryym/operator-camelize.vim'
  let a:conf.depends = ['operator_user']
  let a:conf.after_load = function('my#plug#operator_camelize#after_load')
endfunction

function! my#plug#operator_camelize#after_load()
  Remap2  nvo mp <Plug>(operator-to-camel)
  Remap2  nvo mP <Plug>(operator-to-pascal)
  Remap2  nvo mk <Plug>(operator-to-snake)
endfunction
