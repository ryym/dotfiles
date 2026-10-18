" Make the left (before) diff window highlight its unique lines as removed,
" and the right (after) window highlight its unique lines as added, like
" most other diff tools do. By default vim highlights both sides the same
" way, so it's hard to tell at a glance which side removed or added lines.
function! my#init#func#diff#setup_enhanced_highlight() abort
  augroup vimrc
    autocmd ColorScheme * call s:define_enhanced_diff_hl_groups()
    autocmd VimEnter * call s:apply_enhanced_diff_hl()
    autocmd OptionSet diff call s:apply_enhanced_diff_hl()
  augroup END
endfunction

function! s:define_enhanced_diff_hl_groups() abort
  " Only copy DiffDelete's background, not its foreground. Many
  " colorschemes fix DiffDelete's foreground color, which would hide
  " syntax highlighting if we linked to it directly.
  call s:link_bg_only('MyDiffAddAsDelete', 'DiffDelete')
  highlight link MyDiffDeleteDim NonText
endfunction

function! s:link_bg_only(name, src) abort
  let id = synIDtrans(hlID(a:src))
  let cterm_bg = synIDattr(id, 'bg', 'cterm')
  let cmd = 'highlight ' . a:name . ' ctermbg=' . (empty(cterm_bg) ? 'NONE' : cterm_bg)
  if has('gui_running') || &termguicolors
    let gui_bg = synIDattr(id, 'bg#')
    let cmd .= ' guibg=' . (empty(gui_bg) ? 'NONE' : gui_bg)
  endif
  execute cmd
endfunction

function! s:apply_enhanced_diff_hl() abort
  let diff_wins = []
  for winnr in range(1, winnr('$'))
    if getwinvar(winnr, '&diff')
      call add(diff_wins, winnr)
    endif
  endfor

  " Only handle the plain 2-way diff case. Window rearrangement (e.g. via
  " `wincmd x`) is not tracked, so the left/right assignment may go stale
  " if windows are swapped after this runs.
  if len(diff_wins) != 2
    return
  endif

  call sort(diff_wins, {a, b -> win_screenpos(a)[1] - win_screenpos(b)[1]})
  let [left, right] = diff_wins

  call setwinvar(left, '&winhighlight', 'DiffAdd:MyDiffAddAsDelete,DiffDelete:MyDiffDeleteDim')
  call setwinvar(right, '&winhighlight', 'DiffDelete:MyDiffDeleteDim')
endfunction

" Highlight Git conflict markers regardless of filetype.
function! my#init#func#diff#setup_conflict_marker_highlight() abort
  call s:define_conflict_marker_hl_groups()
  augroup vimrc
    autocmd ColorScheme * call s:define_conflict_marker_hl_groups()
    autocmd VimEnter,WinEnter,BufWinEnter,FileType * call s:sync_conflict_marker_matches()
  augroup END
endfunction

function! s:define_conflict_marker_hl_groups() abort
  " Each marker kind gets its own background color with a white foreground.
  highlight link MyConflictMarkerOurs DiffAdd
  highlight link MyConflictMarkerTheirs DiffChange
  highlight link MyConflictMarkerBase DiffDelete
  highlight link MyConflictMarkerSeparator DiffDelete
endfunction

" Filetypes where the lines that look like conflict markers are legitimate content.
let s:conflict_marker_ignored_filetypes = ['markdown']

" Matches are window-local while the buffer (and its filetype) in a window can change,
" so we sync the matches with the current buffer every time.
function! s:sync_conflict_marker_matches() abort
  let ignored = index(s:conflict_marker_ignored_filetypes, &filetype) >= 0
  let registered = exists('w:my_conflict_marker_matches')

  if ignored && registered
    for id in w:my_conflict_marker_matches
      silent! call matchdelete(id)
    endfor
    unlet w:my_conflict_marker_matches
  elseif !ignored && !registered
    " Use matchadd() instead of syntax rules so that it works even when the buffer is
    " highlighted by Treesitter rather than the legacy syntax.
    let w:my_conflict_marker_matches = [
      \ matchadd('MyConflictMarkerOurs', '^<\{7}\%(\s.*\)\?$'),
      \ matchadd('MyConflictMarkerBase', '^|\{7}\%(\s.*\)\?$'),
      \ matchadd('MyConflictMarkerSeparator', '^=\{7}\%(\s.*\)\?$'),
      \ matchadd('MyConflictMarkerTheirs', '^>\{7}\%(\s.*\)\?$'),
      \ ]
  endif
endfunction
