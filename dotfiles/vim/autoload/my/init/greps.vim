" Define multiple grep commands and enable to switch them easily.
"""

function! s:make_grepprg_obj(program, command, grepprg)
  return {
    \ 'program' : a:program,
    \ 'command' : a:command,
    \ 'grepprg' : a:grepprg,
    \ 'executable' : a:program !=# 'vim' ? executable(a:program) : 1
    \ }
endfunction

let s:grepprgs = {
  \ 'order' : ['git', 'ag', 'pt', 'vim'],
  \ 'prgs' : {
  \   'git' : s:make_grepprg_obj('git', 'GitGrep', 'git grep -n'),
  \   'ag'  : s:make_grepprg_obj('ag', 'AgGrep', 'ag --nocolor --nogroup'),
  \   'pt'  : s:make_grepprg_obj('pt', 'PtGrep', 'pt --nocolor --nogroup'),
  \   'vim' : s:make_grepprg_obj('vim', 'VimGrep', 'internal')
  \  }
  \ }

function! my#init#greps#define() abort
  let s:grepprgs.current = s:select_first_executable_grepprg()

  command! ShowGreps echo 'Available greps: ' <SID>display_available_greps()
  command! -nargs=1 ChangeGrep call <SID>change_grep_program(<q-args>)

  " Define the Grep and GrepAdd commands for each program.
  for config in values(s:grepprgs.prgs)
    execute printf(
      \   "command! -bang -nargs=+ %s call <SID>grep_by(0, '<bang>', '%s', <q-args>)",
      \   config.command,
      \   config.program
      \ )
    execute printf(
      \   "command! -bang -nargs=+ %sAdd call <SID>grep_by(1, '<bang>' '%s', <q-args>)",
      \   config.command,
      \   config.program,
      \ )
  endfor

  MapNamedKey <Space>s grep
  Map n (expr) \[grep]s my#init#greps#_grep_by_current(0)
  Map n (expr) \[grep]+ my#init#greps#_grep_by_current(1)
  Map n \[grep]l ::ShowGreps
  Map n \[grep]a ::ChangeGrep ag
  Map n \[grep]g ::ChangeGrep git
  Map n \[grep]v ::ChangeGrep git
endfunction

function! my#init#greps#_grep_by_current(is_append_mode)
  let command = s:grepprgs.current.command
  return ':' . command . (a:is_append_mode ? 'Add' : '') . '! '
endfunction

function! s:select_executable_programs()
  return filter(copy(s:grepprgs.order), "s:grepprgs.prgs[v:val].executable")
endfunction

function! s:select_first_executable_grepprg()
  let executables = s:select_executable_programs()
  return s:grepprgs.prgs[executables[0]]
endfunction

function! s:display_available_greps()
  let greps = s:select_executable_programs()
  let current = s:grepprgs.current.program
  return join( map(greps, "v:val ==# current ? '['.v:val.']' : v:val "), ' ' )
endfunction

" Run grep by the specified program.
function! s:grep_by(is_append_mode, bang, program, args)
  let saved_grepprg = &grepprg

  let config = s:grepprgs.prgs[a:program]
  let &grepprg = config.grepprg
  let grep = 'grep' . (a:is_append_mode ? 'add' : '') . a:bang

  " https://stackoverflow.com/questions/5669194/how-can-i-escape-the-and-characters-in-a-vim-command
  let escaped_args = substitute(a:args, '\([#%]\)', {m -> '\\' . m[1]}, 'g')

  silent execute grep escaped_args '| cwindow | redraw!'
  echo len(getqflist()) "matches."
  let &grepprg = saved_grepprg
endfunction

function! s:change_grep_program(program) abort
  if ! has_key(s:grepprgs.prgs, a:program)
    echoerr a:program 'is unknown as a grep command.'
    return
  endif

  let config = s:grepprgs.prgs[a:program]
  if ! config.executable
    echoerr a:program 'can not be executed.'
    return
  endif

  let s:grepprgs.current = config
  echo 'Grep is set to:' a:program
endfunction
