" https://github.com/junegunn/fzf/blob/master/README-VIM.md

function! my#plug#fzf#configure(conf) abort
  let a:conf.repo = 'junegunn/fzf'
  let a:conf.install_if = executable('fzf')
  let a:conf.async.enabled = 0
  let a:conf.after_load = function('my#plug#fzf#after_load')
endfunction

function! my#plug#fzf#after_load()
  call my#plug#fzf#tab_buffers#enable()

  MapNamedKey <Space>u fzf

  Map n \[fzf]f ::call my#plug#fzf#_without_ignored_files()
  Map n \[fzf]F ::call my#plug#fzf#_all_files()
  Map n \[fzf]b ::call my#plug#fzf#_tab_buffers()
  Map n \[fzf]m ::call my#plug#fzf#_most_recently_used()
  Map n \[fzf]l ::call my#plug#fzf#_lines()
  Map n \[fzf]g ::call my#plug#fzf#_ghq()
  Map n \[fzf]G ::call my#plug#fzf#_gosrc()
  Map n \[fzf]i ::call my#plug#fzf#_init_scripts()
  Map n \[fzf]p ::call my#plug#fzf#_plugin_confs()
  Map n \[fzf]P ::call my#plug#fzf#_plugin_dirs()
  Map n \[fzf]_r ::call my#plug#fzf#_runtimepaths()
  Map n \[fzf]o :us:FZFoutput
endfunction

let s:fd_available = executable('fd')

let g:fzf_preview_window = ['right:50%', 'ctrl-/']
let s:bat_preview_opt = "--preview='bat --plain --color=always --line-range :100 {}'"

function! my#plug#fzf#_without_ignored_files() abort
  " https://github.com/sharkdp/fd
  " fd is so fast and it respects .gitignore by default.
  let src = s:fd_available ? 'fd --hidden --type f --exclude .git' : 'git ls-files'
  call fzf#run({
    \   'sink': 'edit',
    \   'source': src,
    \   'up': '35%',
    \   'options': s:bat_preview_opt,
    \ })
endfunction

function! my#plug#fzf#_all_files()
  call fzf#run({ 'sink': funcref('my#plug#fzf#_open_file_or_dir') })
endfunction

function! my#plug#fzf#_open_file_or_dir(...)
  if len(a:000) > 1
    let prefix = len(a:000) > 1 ? a:000[0] : ''
    let path = prefix . a:000[1]
  else
    let path = a:000[0]
  endif

  if isdirectory(path)
    execute 'cd' fnameescape(path)
  else
    execute 'edit' fnameescape(path)
  endif
endfunction

function! my#plug#fzf#_tab_buffers() abort
  call fzf#run({
    \   'sink*': function('my#plug#fzf#_tab_buffers_on_select'),
    \   'source': my#plug#fzf#tab_buffers#list_others(tabpagenr()),
    \   'up': '35%',
    \   'options': '--multi --expect=ctrl-d ' . s:bat_preview_opt
    \ })
endfunction

function! my#plug#fzf#_tab_buffers_on_select(names) abort
  if len(a:names) == 0
    return
  endif
  if a:names[0] == 'ctrl-d'
    for name in a:names[1:]
      execute 'bdelete' fnameescape(name)
    endfor
  else
    execute 'edit' fnameescape(a:names[1])
  endif
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

function! my#plug#fzf#_plugin_confs() abort
  let src = s:fd_available ? 'fd --type f' : ''
  call fzf#run({
    \   'sink': 'edit',
    \   'source': src,
    \   'dir': $MYVIMDIR . '/autoload/my/plug',
    \   'up': '35%',
    \   'options': s:bat_preview_opt,
    \ })
endfunction

function! my#plug#fzf#_init_scripts() abort
  let main_files = [$MYVIMDIR . '/vimrc']
  if has('nvim')
    call add(main_files, $MYVIMDIR . '/init.vim')
  endif
  let init_root = $MYVIMDIR . '/autoload/my/init'
  let init_files = [init_root . '.vim'] + globpath(init_root, '**', 0, 1)
  call fzf#run({
    \   'sink': 'edit',
    \   'source': main_files + init_files,
    \   'up': '35%',
    \ })
endfunction

function! my#plug#fzf#_plugin_dirs() abort
  let packdir = $MYVIMDIR . '/pack/'
  call fzf#run({
    \   'sink': funcref('my#plug#fzf#_open_file_or_dir', [packdir]),
    \   'source': 'gits ' . packdir,
    \   'up': '35%',
    \ })
endfunction

function! my#plug#fzf#_runtimepaths() abort
  let paths = split(&runtimepath, ',')
  call fzf#run({
    \   'sink': 'cd',
    \   'source': paths,
    \   'up': '35%',
    \ })
endfunction
