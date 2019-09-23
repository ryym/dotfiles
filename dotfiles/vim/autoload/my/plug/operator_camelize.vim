function! my#plug#operator_camelize#configure(conf) abort
  let a:conf.repo = 'ryym/operator-camelize.vim'
  let a:conf.depends = ['operator_user']
  let a:conf.after_load = function('my#plug#operator_camelize#after_load')
endfunction

function! my#plug#operator_camelize#after_load()
  Remap  nvo mp <Plug>(operator-to-camel)
  Remap  nvo mP <Plug>(operator-to-pascal)
  Remap  nvo mk <Plug>(operator-to-snake)
endfunction
