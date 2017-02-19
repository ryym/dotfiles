function! my#conf#vimproc#hook_post_update()
  if g:is_windows
    let g:dein#plugin.disabled = 1
    return
  endif

  let cmd = ''
  if g:is_mac
    let cmd = 'make -f make_mac.mak'
  elseif executable('gmake')
    let cmd = 'gmake'
  else
    let cmd = 'make'
  endif

  let g:dein#plugin.build = cmd
endfunction
