function! my#plug#asyncomplete_lsp#configure(conf) abort
  let a:conf.repo = 'prabirshrestha/asyncomplete-lsp.vim'
  let a:conf.depends = ['asyncomplete']
endfunction
