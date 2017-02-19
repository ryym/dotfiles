function! my#conf#editing#lexima_hook_post_source()
  " For vspec
  call lexima#add_rule({
    \ 'char'        : '<CR>',
    \ 'input_after' : '<CR>end',
    \ 'at'          : '^\s*\%(describe\|it\|context\)\s\+.\+\%#',
    \ 'filetype'    : 'vim'
    \ })
  call lexima#add_rule({
    \ 'char'        : '<CR>',
    \ 'input_after' : '<CR>end',
    \ 'at'          : '^\s*\%(before\|after\)\s*\%#',
    \ 'filetype'    : 'vim'
    \ })

  " Supress auto-closing for folds in vim
  call lexima#add_rule({
    \ 'char'     : '{',
    \ 'input'    : '{',
    \ 'at'       : '{{\%#',
    \ 'delete'   : 2,
    \ 'filetype' : 'vim'
    \ })
  call lexima#add_rule({
    \ 'char'     : '<CR>',
    \ 'input'    : '<CR>',
    \ 'at'       : '{\{3\}\%#',
    \ 'filetype' : 'vim'
    \ })
endfunction

function! my#conf#editing#yankround_hook_source()
  Remap nx p     <Plug>(yankround-p)
  Remap n  P     <Plug>(yankround-P)
  Remap nx gp    <Plug>(yankround-gp)
  Remap n  gP    <Plug>(yankround-gP)
  Remap n <C-p> <Plug>(yankround-prev)
  Remap n <C-n> <Plug>(yankround-next)
endfunction

function my#conf#editing#unimpaired_hook_source()
  let g:unimpaired_mapping = {
    \ 'encodings' : 0,
    \ 'excludes'  : {
    \     'nextprevs' : ['n'],
    \     'toggles'   : ['c', 'h', 'i', 's']
    \   }
    \ }
endfunction

function my#conf#editing#unimpaired_hook_post_source()
  Remap no [d <Plug>unimpairedContextPrevious
  Remap no ]d <Plug>unimpairedContextNext

  call g:Unimpaired_toggle_option_by('t', 'expandtab')
  call g:Unimpaired_toggle_option_by('s', 'scrollbind')
  call g:Unimpaired_toggle_option_by('p', 'spell')
endfunction
