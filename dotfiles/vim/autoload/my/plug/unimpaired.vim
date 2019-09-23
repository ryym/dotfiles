function! my#plug#unimpaired#configure(conf) abort
  let a:conf.repo = 'ryym/vim-unimpaired'
  let a:conf.depends = ['repeat']
  let a:conf.before_load = function('my#plug#unimpaired#before_load')
  let a:conf.after_load = function('my#plug#unimpaired#after_load')
endfunction

function! my#plug#unimpaired#before_load()
  let g:unimpaired_mapping = {
    \ 'encodings' : 0,
    \ 'excludes'  : {
    \     'nextprevs' : ['n'],
    \     'toggles'   : ['c', 'h', 'i', 's']
    \   }
    \ }
endfunction

function! my#plug#unimpaired#after_load()
  Remap no [d <Plug>unimpairedContextPrevious
  Remap no ]d <Plug>unimpairedContextNext

  call g:Unimpaired_toggle_option_by('t', 'expandtab')
  call g:Unimpaired_toggle_option_by('s', 'scrollbind')
  call g:Unimpaired_toggle_option_by('p', 'spell')
endfunction
