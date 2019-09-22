function! my#plug#lexima#configure(conf) abort
  let a:conf.repo = 'cohama/lexima.vim'
  let a:conf.after_load = function('my#plug#lexima#after_load')
endfunction

function! my#plug#lexima#after_load() abort
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

  " Supress auto-closing of single quotes (lifetimes) in Rust.
  call lexima#add_rule({
    \ 'char'     : "'",
    \ 'filetype' : 'rust'
    \ })
endfunction
