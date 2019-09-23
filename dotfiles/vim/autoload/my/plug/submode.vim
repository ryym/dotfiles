function! my#plug#submode#configure(conf) abort
  let a:conf.repo = 'kana/vim-submode'
  let a:conf.before_load = function('my#plug#submode#before_load')
  let a:conf.after_load = function('my#plug#submode#after_load')
endfunction

function! my#plug#submode#before_load()
  let g:submode_keep_leaving_key = 1
  let g:submode_timeout = 0
  let g:submode_timeoutlen = 3000
endfunction

function! my#plug#submode#after_load()
  command! -nargs=1 SbmDefine call my#plug#submode#define(<f-args>)

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

" Define ex commands which wraps functions of vim-submode.
function! my#plug#submode#define(name)
  let capit_name = toupper(a:name[0]) . a:name[1:]
  call s:define_sbm_command(a:name, capit_name . 'Enter', 'enter_with')
  call s:define_sbm_command(a:name, capit_name . 'Leave', 'leave_with')
  call s:define_sbm_command(a:name, capit_name, 'map')
  call s:define_sbm_command(a:name, capit_name . 'Unmap', 'unmap')
endfunction

function! my#plug#submode#enter_with(name, ...)
  let args = s:normalize_args(a:name, a:000, 4)
  call call('submode#enter_with', args)
endfunction

function! my#plug#submode#leave_with(name, ...)
  let args = s:normalize_args(a:name, a:000, 3)
  call call('submode#leave_with', args)
endfunction

function! my#plug#submode#map(name, ...)
  let args = s:normalize_args(a:name, a:000, 4)
  call call('submode#map', args)
endfunction

function! my#plug#submode#unmap(name, ...)
  let args = s:normalize_args(a:name, a:000, 3)
  call call('submdoe#unmap', args)
endfunction

let s:args_idx_options = 2

function! s:define_sbm_command(submode_name, command_name, function_name)
  execute 'command! -nargs=+ Sbm' . a:command_name
    \ 'call my#plug#submode#' . a:function_name . "('" . a:submode_name . "', <f-args>)"
endfunction

function! s:normalize_args(name, args, n_full_args)
  let normalized_args = [a:name] + copy(a:args)
  let len_args = len(a:args)

  if len_args < a:n_full_args
    call insert(normalized_args, '', s:args_idx_options) " Insert empty options.
  elseif len_args == a:n_full_args
    let options = normalized_args[s:args_idx_options]
    if options =~ '^<[^>]\+>$'
      let normalized_args[s:args_idx_options] = options[1 : -2] " Remove '<' & '>'.
    endif
  endif

  return normalized_args
endfunction
