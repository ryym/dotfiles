" https://github.com/junegunn/fzf/blob/master/README-VIM.md

function! my#plug#fzf#configure(conf) abort
  let a:conf.repo = 'junegunn/fzf'
  let a:conf.install_if = executable('fzf')
  let a:conf.after_load = function('my#plug#fzf#after_load')
endfunction

function! my#plug#fzf#after_load()
  MapNamedKey <Space>u fzf

  Map n \[fzf]f ::call my#plug#fzf#_without_ignored_files()
  Map n \[fzf]F ::call my#plug#fzf#_all_files()
  Map n \[fzf]b ::call my#plug#fzf#_tabpage_buffers()
  Map n \[fzf]m ::call my#plug#fzf#_most_recently_used()
  Map n \[fzf]l ::call my#plug#fzf#_lines()
  Map n \[fzf]g ::call my#plug#fzf#_ghq()
  Map n \[fzf]G ::call my#plug#fzf#_gosrc()
  Map n \[fzf]p ::call my#plug#fzf#_plugins()
  Map n \[fzf]o :us:FZFoutput
endfunction

let s:fd_available = executable('fd')

function! my#plug#fzf#_without_ignored_files() abort
  " https://github.com/sharkdp/fd
  " fd is so fast and it respects .gitignore by default.
  let src = s:fd_available ? 'fd --hidden --type f' : 'git ls-files'
  call fzf#run({
    \   'sink': 'edit',
    \   'source': src,
    \   'up': '35%',
    \ })
endfunction

function! my#plug#fzf#_all_files()
  call fzf#run({ 'sink': funcref('my#plug#fzf#_open_file_or_dir') })
endfunction

function! my#plug#fzf#_open_file_or_dir(name)
  if isdirectory(a:name)
    execute 'cd' a:name
  else
    execute 'edit' a:name
  endif
endfunction

" TODO: Sort buffers by last open time.
function! my#plug#fzf#_tabpage_buffers() abort
  let bufs = gettabvar(tabpagenr(), 'tabpagebuffer')
  let bufnrs = map(keys(bufs), 'str2nr(v:val, 10)')
  call fzf#run({
    \   'sink': 'edit',
    \   'source': map(filter(bufnrs, 'buflisted(v:val)'), 'bufname(v:val)'),
    \   'up': '35%',
    \ })
endfunction

command! -nargs=1 FZFoutput call my#plug#fzf#_outputs(<q-args>)
function! my#plug#fzf#_outputs(cmd) abort
  let outputs = split(execute(a:cmd), '\n')
  call fzf#run({
    \   'source': outputs,
    \   'up': '35%',
    \ })
endfunction

function! my#plug#fzf#_lines() abort
  let scale = len(string(line('$')))
  let lines = map(getline(1, '$'), {idx, v -> printf("% ".scale."d", idx+1) . '| ' . v})

  call fzf#run({
    \   'sink*': funcref('my#plug#fzf#_lines_on_select', [scale]),
    \   'source': lines,
    \   'options': '--multi --reverse --expect=ctrl-y',
    \ })
endfunction
function! my#plug#fzf#_lines_on_select(width, lines) abort
  if len(a:lines) == 0
    return
  endif
  if a:lines[0] == 'ctrl-y'
    let lines = map(a:lines[1:], {_i, l -> substitute(l, '^\s*\d\+|\s', '', '')})
    " Copy the selected lines.
    call setreg('*', join(lines, "\n"))
  else
    " Go to the selected line.
    let ln = str2nr(a:lines[1][0:a:width])
    execute ln
  endif
endfunction

function! my#plug#fzf#_ghq() abort
  call fzf#run({
    \   'sink': 'cd',
    \   'source': 'ghq list -p',
    \   'up': '35%',
    \ })
endfunction

function! my#plug#fzf#_gosrc() abort
  call fzf#run({
    \   'sink': 'cd',
    \   'source': 'gits -p $GOPATH/src',
    \   'up': '35%',
    \ })
endfunction

function! my#plug#fzf#_most_recently_used() abort
  call fzf#run({
    \   'sink': 'edit',
    \   'source': v:oldfiles,
    \   'up': '35%',
    \ })
endfunction

function! my#plug#fzf#_plugins() abort
  call fzf#run({
    \   'sink': funcref('my#plug#fzf#_open_file_or_dir'),
    \   'source': 'gits ~/.vim/pack',
    \   'up': '35%',
    \ })
endfunction
