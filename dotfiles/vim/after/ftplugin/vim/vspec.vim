" vspec filetype plugin for folding
" Ref: https://github.com/thinca/vim-themis/commit/9b0156af1f38e279cdb9df0bffbbf2a74521d69f

if exists('b:did_fold')
  finish
endif
let b:did_fold = 1

setlocal foldexpr=GetVspecFold(v:lnum)

function! GetVspecFold(lnum) abort " {{{
  let line = getline(a:lnum)
  if line =~# s:pattern_folds
    return 'a1'
  elseif line =~# s:pattern_folde
    return 's1'
  endif
  return '='
endfunction " }}}

let s:pattern_folds = '\v^\s*%(describe|context|it|before|after)'
let s:pattern_folde = '\v^\s*end$'
