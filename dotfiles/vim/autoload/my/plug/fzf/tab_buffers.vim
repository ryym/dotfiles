" Manage buffer list per tab.
" Reference: https://github.com/Shougo/tabpagebuffer.vim

function! my#plug#fzf#tab_buffers#enable() abort
  augroup my_fzf_tab_buffer
    autocmd!
    autocmd BufEnter,BufWinEnter,BufFilePost * call s:append_buffer(expand('<abuf>'))
    autocmd BufDelete * call s:remove_buffer(expand('<abuf>'))
  augroup END
endfunction

function! my#plug#fzf#tab_buffers#list_others(tabnr) abort
  let bufs = gettabvar(a:tabnr, 'tab_buffers', {})

  let bufnrs = values(bufs)
    \ ->sort({a, b -> a.displayed < b.displayed ? 1 : -1})
    \ ->map('v:val.nr')

  " The current buffer must be displayed most recently.
  " We remove it from list because we use this list to switch
  " to another buffer.
  let bufnrs = bufnrs[1:]

  return bufnrs->filter('buflisted(v:val)')->map('bufname(v:val)')
endfunction

function! s:append_buffer(bufnr) abort
  if !exists('t:tab_buffers')
    let t:tab_buffers = {}
  endif

  for tabnr in range(1, tabpagenr('$'))
    let bufs = gettabvar(tabnr, 'tab_buffers')
    if has_key(bufs, a:bufnr)
      call remove(bufs, a:bufnr)
    endif
  endfor

  let t:tab_buffers[a:bufnr] = {
    \   'nr': str2nr(a:bufnr),
    \   'displayed': reltimestr(reltime()),
    \ }
endfunction

function! s:remove_buffer(bufnr) abort
  " I don't inspect the detail match but there is a case
  " that this `remove_buffer` is called without calling the
  " `append_buffer` function.
  if exists('t:tab_buffers') && has_key(t:tab_buffers, a:bufnr)
    call remove(t:tab_buffers, a:bufnr)
  endif
endfunction
