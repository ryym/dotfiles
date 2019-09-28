" Manage buffer list per tab.
" Reference: https://github.com/Shougo/tabpagebuffer.vim

function! my#plug#fzf#tab_buffers#enable() abort
  augroup my_fzf_tab_buffer
    autocmd!
    autocmd BufEnter,BufWinEnter,BufFilePost * call s:append_buffer(expand('<abuf>'))
    autocmd BufDelete * call s:remove_buffer(expand('<abuf>'))
  augroup END
endfunction

function! my#plug#fzf#tab_buffers#list(tabnr) abort
  let bufs = gettabvar(a:tabnr, 'tab_buffers', {})
  let bufnrs = map(keys(bufs), 'str2nr(v:val, 10)')
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

  let t:tab_buffers[a:bufnr] = 1
endfunction

function! s:remove_buffer(bufnr) abort
  call remove(t:tab_buffers, a:bufnr)
endfunction
