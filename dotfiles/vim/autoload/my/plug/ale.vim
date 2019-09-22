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
endfunction
