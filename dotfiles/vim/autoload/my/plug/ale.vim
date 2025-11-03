function! my#plug#ale#configure(conf) abort
  let a:conf.repo = 'w0rp/ale'
  let a:conf.before_load = function('my#plug#ale#before_load')
endfunction

function my#plug#ale#before_load()
  let g:ale_linters_explicit = 1
  let g:ale_fix_on_save = 1
  let g:ale_fixers = {
    \ 'rust': ['rustfmt'],
    \ 'elm': ['elm-format'],
    \ 'terraform': ['terraform'],
    \ }
  let g:ale_fixers.javascript = ['prettier']
  let g:ale_fixers.javascriptreact = ['prettier']
  let g:ale_fixers.typescript = ['prettier']
  let g:ale_fixers.css = ['prettier']
  let g:ale_fixers.scss = ['prettier']
  let g:ale_fixers.json = ['prettier']
  let g:ale_fixers.json5 = ['prettier']
  let g:ale_fixers.html = ['prettier']
  let g:ale_fixers.graphql = ['prettier']
  let g:ale_fixers.markdown = ['prettier']
  let g:ale_fixers.go = ['goimports']

  let g:ale_rust_rustfmt_options = '--edition 2024'

  MapNamedKey <Leader>a ale
  Map n \[ale]f ::ALEFix
endfunction
