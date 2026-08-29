function! my#init#func#buf#setup_autocmds() abort
  " Record the unresolved (symlink-preserving) path of a buffer at the moment
  " it is opened, since Vim keeps only the symlink-resolved physical path once
  " ':cd'/':lcd' or a window switch has forced the display name to be rebuilt:
  "     :edit symlinked/file | expand('%') -> symlinked/file
  "     :lcd .               | expand('%') -> /abs/path/to/real/file
  augroup vimrc
    " Allow to force update the path only for `BufFilePost` since it can fire
    " on `:file` or `:saveas` which changes the actual file path.
    autocmd BufFilePost                   * call s:capture_unresolved_path(1)
    autocmd BufNew,BufReadPost,BufNewFile * call s:capture_unresolved_path(0)
  augroup END
endfunction

" Record the buffer name into 'b:unresolved_path' as an unresolved absolute path.
function! s:capture_unresolved_path(force) abort
  if !a:force && exists('b:unresolved_path')
    return
  endif
  let name = bufname('')
  if empty(name) || name =~# '^\a\+://'
    return
  endif
  let b:unresolved_path = name[0] ==# '/' ? name : simplify(getcwd() . '/' . name)
endfunction

" Return an absolute path of the specified buffer.
" If the corresponding file is in a symlinked directory,
" it returns an unresolved (symlink-perserving) path.
function! my#init#func#buf#abs_path(buf) abort
  let nr = bufnr(a:buf)
  let fallback = fnamemodify(bufname(nr), ':p')
  return getbufvar(nr, 'unresolved_path', fallback)
endfunction
