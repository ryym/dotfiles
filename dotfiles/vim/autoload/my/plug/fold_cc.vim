function! my#plug#fold_cc#configure(conf) abort
  let a:conf.repo = 'LeafCage/foldCC.vim'
  let a:conf.before_load = function('my#plug#fold_cc#before_load')
endfunction

function! my#plug#fold_cc#before_load()
  let g:foldCCtext_head = "printf('%s %d: ', repeat(v:folddashes, v:foldlevel), v:foldlevel)"
  let g:foldCCtext_tail = "printf('%d lines ', v:foldend - v:foldstart + 1)"
  set foldtext=FoldCCtext()
endfunction
