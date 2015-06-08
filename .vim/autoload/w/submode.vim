"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" The wrapper of submode.vim
"
" The mini vim-submode wrapper
" to define ex commands for each submode.
"""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Globals {{{

" Define ex commands which wraps functions of vim-submode.
function! w#submode#define(name)
  let capit_name = toupper(a:name[0]) . a:name[1:]
  call s:define_sbm_command(a:name, capit_name . 'Enter', 'enter_with')
  call s:define_sbm_command(a:name, capit_name . 'Leave', 'leave_with')
  call s:define_sbm_command(a:name, capit_name, 'map')
  call s:define_sbm_command(a:name, capit_name . 'Unmap', 'unmap')
endfunction

function! w#submode#enter_with(name, ...)
  let args = s:normalize_args(a:name, a:000, 4)
  call call('submode#enter_with', args)
endfunction

function! w#submode#leave_with(name, ...)
  let args = s:normalize_args(a:name, a:000, 3)
  call call('submode#leave_with', args)
endfunction

function! w#submode#map(name, ...)
  let args = s:normalize_args(a:name, a:000, 4)
  call call('submode#map', args)
endfunction

function! w#submode#unmap(name, ...)
  let args = s:normalize_args(a:name, a:000, 3)
  call call('submdoe#unmap', args)
endfunction

" }}}

" Script locals {{{

let s:args_idx_options = 2

function! s:define_sbm_command(submode_name, command_name, function_name)
  execute 'command! -nargs=+ Sbm' . a:command_name
    \ 'call w#submode#' . a:function_name . "('" . a:submode_name . "', <f-args>)"
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

" }}}
