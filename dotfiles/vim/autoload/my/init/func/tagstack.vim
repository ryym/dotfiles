" Tag stack navigation with a working "forward" step.
" While Vim provides builtin navigation commands (:pop and :tag),
" there is no simple forward navigation that follows the current tag stack.
" (see :help tagstack)

function! s:warn(msg) abort
  echohl WarningMsg
  echomsg 'tagstack: ' . a:msg
  echohl None
endfunction

" pos is in getpos() format: [bufnr, lnum, col, off]
function! s:goto(pos) abort
  let l:bufnr = a:pos[0]
  if !bufexists(l:bufnr)
    call s:warn('buffer ' . l:bufnr . ' no longer exists')
    return 0
  endif
  if l:bufnr != bufnr('%')
    execute 'buffer' l:bufnr
  endif
  call cursor(a:pos[1], a:pos[2])
  normal! zv
  return 1
endfunction

" Jump to the previous entry.
function! my#init#func#tagstack#prev(count) abort
  let l:stack = gettagstack()
  if l:stack.curidx <= 1
    call s:warn('already at the oldest entry')
    return
  endif
  if l:stack.curidx > len(l:stack.items)
    let w:tagstack_top = [bufnr('%'), line('.'), col('.'), 0]
    let w:tagstack_top_len = len(l:stack.items)
  endif
  execute min([a:count, l:stack.curidx - 1]) . 'pop'
endfunction

" Jump to the next entry.
function! my#init#func#tagstack#next(count) abort
  let l:stack = gettagstack()
  let l:last = len(l:stack.items)
  if l:stack.curidx > l:last
    call s:warn('already at the newest entry')
    return
  endif

  let l:target = min([l:stack.curidx + a:count, l:last + 1])
  let l:top_known = exists('w:tagstack_top') && w:tagstack_top_len == l:last
  if l:target > l:last && !l:top_known
    " Nothing recorded for the newest position, so stop one entry short.
    let l:target = l:last
    if l:target <= l:stack.curidx
      call s:warn('newest position unknown')
      return
    endif
  endif

  let l:pos = l:target > l:last ? w:tagstack_top : l:stack.items[l:target - 1].from
  if !s:goto(l:pos)
    return
  endif
  call settagstack(win_getid(), {'curidx': l:target})
endfunction

" Jump straight to the oldest entry.
function! my#init#func#tagstack#first() abort
  call my#init#func#tagstack#prev(len(gettagstack().items))
endfunction

" Jump straight to the newest entry.
function! my#init#func#tagstack#last() abort
  call my#init#func#tagstack#next(len(gettagstack().items) + 1)
endfunction
