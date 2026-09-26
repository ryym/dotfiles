function! my#init#func#window#split_from_buf(opt) abort
  let src_win = win_getid()
  call my#init#func#window#split_by_ratio(src_win, a:opt)
endfunction

function! my#init#func#window#split_from_term(opt) abort
  let src_win = win_getid()
  call my#init#func#window#split_by_ratio(src_win, a:opt)

  " The src window is now in normal mode so reset it to the terminal mode.
  " Without this, we need to change the mode manually when we back to the
  " src window. This is cumbersome.
  let dest_win = win_getid()
  call win_gotoid(src_win)
  normal i
  call win_gotoid(dest_win)
endfunction

" Split window and specify its size by ratio.
" You can specify the new window is a terminal or not.
" opt : {vert: bool, term: bool, ratio: 0}
function! my#init#func#window#split_by_ratio(src_win, opt) abort
  let is_vertical = get(a:opt, 'vert', 0)
  let prefix = is_vertical ? 'vertical' : ''
  let cur_size = is_vertical ? winwidth(a:src_win) : winheight(a:src_win)

  let sb = &splitbelow
  let sr = &splitright
  try
    " Immitate Tmux splitting.
    " This feels more natural to me.
    setlocal splitbelow
    setlocal splitright
    execute prefix 'split'
  finally
    let &splitbelow = sb
    let &splitright = sr
  endtry

  if get(a:opt, 'term', 0)
    execute has('nvim') ? 'terminal' : 'terminal ++curwin'
  else
    enew
  endif

  if has_key(a:opt, 'ratio')
    let desired_size = cur_size * a:opt.ratio
    execute prefix 'resize' string(desired_size)
  endif
endfunction

" Move to the window in the direction like `wincmd {dir}`, but prefer the previous
" window if it is next to the current one in that direction. This imitates Tmux.
function! my#init#func#window#move(dir) abort
  let prev = winnr('#')
  if prev > 0 && prev != winnr() && s:is_adjacent(winnr(), prev, a:dir)
    execute prev . 'wincmd w'
  else
    execute 'wincmd' a:dir
  endif
endfunction

function! s:is_adjacent(cur, other, dir) abort
  let [cr, cc] = win_screenpos(a:cur)
  let [ch, cw] = [winheight(a:cur), winwidth(a:cur)]
  let [or, oc] = win_screenpos(a:other)
  let [oh, ow] = [winheight(a:other), winwidth(a:other)]
  let rows_overlap = or <= cr + ch - 1 && cr <= or + oh - 1
  let cols_overlap = oc <= cc + cw - 1 && cc <= oc + ow - 1
  if a:dir ==# 'h'
    return rows_overlap && oc + ow + 1 == cc
  elseif a:dir ==# 'l'
    return rows_overlap && cc + cw + 1 == oc
  elseif a:dir ==# 'k'
    " The gap is the status line (and the winbar if any).
    return cols_overlap && or + oh < cr && cr - (or + oh) <= 2
  else
    return cols_overlap && cr + ch < or && or - (cr + ch) <= 2
  endif
endfunction
