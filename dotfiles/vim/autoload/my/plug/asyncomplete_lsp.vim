function! my#plug#asyncomplete_lsp#configure(conf) abort
  let a:conf.repo = 'prabirshrestha/asyncomplete-lsp.vim'
  let a:conf.depends = ['asyncomplete']
  let a:conf.async.enabled = 0
endfunction
