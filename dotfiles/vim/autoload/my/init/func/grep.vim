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
  \ 'current': 'git',
  \ 'order' : ['git', 'rg', 'vim'],
  \ 'prgs' : {
  \   'git' : s:make_grepprg_obj('git', 'GitGrep', 'git grep --line-number --column'),
  \   'rg'  : s:make_grepprg_obj('rg', 'RgGrep', 'rg --vimgrep'),
  \   'vim' : s:make_grepprg_obj('vim', 'VimGrep', 'internal')
  \  }
  \ }

function! s:grepprgs.current_prg() abort
  return self.prgs[self.current]
endfunction

" Run grep by the specified program.
function! my#init#func#grep#by(is_append_mode, bang, program, args)
  let saved_grepprg = &grepprg

  let config = s:grepprgs.prgs[a:program]
  let &grepprg = config.grepprg
  let grep = 'grep' . (a:is_append_mode ? 'add' : '') . a:bang

  " https://stackoverflow.com/questions/5669194/how-can-i-escape-the-and-characters-in-a-vim-command
  let escaped_args = substitute(a:args, '\([#%]\)', {m -> '\\' . m[1]}, 'g')

  silent execute grep escaped_args '| botright cwindow | redraw!'
  echo len(getqflist()) "matches."
  let &grepprg = saved_grepprg
endfunction

function! my#init#func#grep#by_current(is_append_mode)
  let command = s:grepprgs.current_prg().command
  return ':' . command . (a:is_append_mode ? 'Add' : '') . '! '
endfunction

function! my#init#func#grep#available_greps()
  let greps = s:select_executable_programs()
  let current = s:grepprgs.current_prg().program
  return join( map(greps, "v:val ==# current ? '['.v:val.']' : v:val "), ' ' )
endfunction

function! my#init#func#grep#change_grep(program) abort
  if ! has_key(s:grepprgs.prgs, a:program)
    echoerr a:program 'is unknown as a grep command.'
    return
  endif

  let config = s:grepprgs.prgs[a:program]
  if ! config.executable
    echoerr a:program 'can not be executed.'
    return
  endif

  let s:grepprgs.current = config.program
  echo 'Grep is set to:' a:program
endfunction

function! s:select_executable_programs()
  return filter(copy(s:grepprgs.order), "s:grepprgs.prgs[v:val].executable")
endfunction

function! s:select_first_executable_grepprg()
  let executables = s:select_executable_programs()
  return s:grepprgs.prgs[executables[0]]
endfunction
