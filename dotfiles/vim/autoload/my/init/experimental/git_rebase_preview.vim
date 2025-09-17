" Experimental: preview each commit durinng Git interactive rebase.
" When you enter a rebase todo list with `git rebase -i`,
" this script will display preview of the commit at the cursor line.

function! my#init#experimental#git_rebase_preview#setup() abort
  augroup vimrc
    autocmd!
    autocmd FileType gitrebase call <SID>update_preview()
    autocmd FileType gitrebase autocmd CursorMoved,CursorMovedI <buffer> call <SID>update_preview()
    autocmd WinClosed * if &filetype == 'gitrebase' | qa | endif
  augroup END

  nnoremap <leader>t :call <SID>toggle_preview_enabled()<CR>
  command! TogglePreviewEnabled call <SID>toggle_preview_enabled()
endfunction

let s:bufnr_by_commit = {}
let s:preview_placeholder_bufnr = -1
let s:preview_winnr = -1
let s:preview_enabled = 1

function! s:update_preview() abort
  if s:preview_enabled == 0
    return
  endif
  if s:preview_winnr == -1 || winwidth(s:preview_winnr) <= 0
    call s:create_preview_window()
  endif

  let commit_hash = s:get_commit_hash_from(getline('.'))
  if empty(commit_hash)
    call s:show_buffer_in_preview(s:preview_placeholder_bufnr)
    return
  endif

  let buffer_num = s:create_terminal_for_commit(commit_hash)
  call s:show_buffer_in_preview(buffer_num)
endfunction

function! s:create_preview_window() abort
  rightbelow vsplit

  if s:preview_placeholder_bufnr == -1
    let s:preview_placeholder_bufnr = s:create_placeholder_buffer()
  endif

  let s:preview_winnr = winnr()
  wincmd p
endfunction

function! s:create_terminal_for_commit(commit_hash) abort
  if has_key(s:bufnr_by_commit, a:commit_hash) && bufexists(s:bufnr_by_commit[a:commit_hash])
    return s:bufnr_by_commit[a:commit_hash]
  endif
  let current_win = winnr()

  tabnew
  let buffer_num = s:create_commit_preview_buffer(a:commit_hash)
  tabclose

  execute current_win . 'wincmd w'
  let s:bufnr_by_commit[a:commit_hash] = buffer_num
  return buffer_num
endfunction

function! s:create_placeholder_buffer() abort
  silent enew
  setlocal buftype=nofile
  setlocal bufhidden=hide
  setlocal nobuflisted
  silent file [Preview]
  return bufnr('%')
endfunction

function! s:create_commit_preview_buffer(commit_hash) abort
  terminal
  setlocal bufhidden=hide
  setlocal nobuflisted
  execute 'silent file [Git Show: ' . a:commit_hash . ']'
  call jobsend(b:terminal_job_id, "git show " . a:commit_hash . " | delta --paging never\n")
  return bufnr('%')
endfunction

function! s:show_buffer_in_preview(buffer_num) abort
  let current_win = winnr()
  execute s:preview_winnr . 'wincmd w'
  execute 'buffer ' . a:buffer_num
  execute current_win . 'wincmd w'
endfunction

function! s:close_preview() abort
  if s:preview_winnr != -1 && winwidth(s:preview_winnr) > 0
    execute s:preview_winnr . 'wincmd w'
    quit
  endif
  let s:preview_winnr = -1
endfunction

function! s:toggle_preview_enabled() abort
  if s:preview_enabled == 1
    call s:close_preview()
    let s:preview_enabled = 0
  else
    let s:preview_enabled = 1
    call s:update_preview()
  endif
endfunction

function! s:get_commit_hash_from(line) abort
  if a:line =~ '^\s*$' || a:line =~ '^\s*#'
    return ''
  endif

  " Examples:
  " pick abc123 commit message
  " f -c abc 123 commit message
  let previewable_line = '\v^\s*([a-z]*)\s+(-[cC]\s+)?([a-f0-9]{6,40})\s.*$'

  let matches = matchlist(a:line, previewable_line)
  if empty(matches)
    return ''
  endif

  return matches[3]
endfunction
