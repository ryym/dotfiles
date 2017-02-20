function! my#conf#submode#hook_source()
  let g:submode_keep_leaving_key = 1
  let g:submode_timeout          = 0
  let g:submode_timeoutlen       = 3000
endfunction

function! my#conf#submode#hook_post_source()
  call my#submode#wrap()

  SbmDefine scroll
  SbmScrollEnter n <Leader>s
  SbmScroll n <r> u <C-u>
  SbmScroll n <r> d <C-d>
  SbmScroll n <r> f <C-f>
  SbmScroll n <r> b <C-b>
  SbmScroll n j     2<C-e>j
  SbmScroll n k     2<C-y>k
  SbmScroll n J     4<C-e>j
  SbmScroll n K     4<C-y>k
  SbmScroll n <C-j> 6<C-e>j
  SbmScroll n <C-k> 6<C-y>k

  SbmDefine winRes
  SbmWinResEnter n <C-w>m
  SbmWinResEnter n <C-w><C-m>

  " 'L'ower, 'H'eighten, 'S'horten, 'W'iden
  for [s:k, s:command] in items({
    \ 'l': '<C-w>-',
    \ 'h': '<C-w>+',
    \ 's': '<C-w><',
    \ 'w': '<C-w>>'
    \ })
    execute 'SbmWinRes n' s:k               1 . s:command
    execute 'SbmWinRes n' toupper(s:k)      3 . s:command
    execute 'SbmWinRes n' '<C-' . s:k . '>' 5 . s:command
  endfor
  unlet s:k s:command

  SbmDefine tab
  SbmTabEnter n tt
  SbmTab n l gt
  SbmTab n h gT
endfunction
