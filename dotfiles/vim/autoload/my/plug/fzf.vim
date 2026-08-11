" https://github.com/junegunn/fzf/blob/master/README-VIM.md

function! my#plug#fzf#configure(conf) abort
  let a:conf.repo = 'junegunn/fzf'
  let a:conf.install_if = executable('fzf')
  let a:conf.async.enabled = 0
  let a:conf.after_load = function('my#plug#fzf#after_load')
endfunction

function! my#plug#fzf#after_load()
  call my#plug#fzf#tab_buffers#enable()

  MapPrefix n <Space>u \[fzf]

  Map n \[fzf]f :<C-u>call my#plug#fzf#_without_ignored_files()<CR>
  Map n \[fzf]F :<C-u>call my#plug#fzf#_all_files()<CR>
  Map n \[fzf]b :<C-u>call my#plug#fzf#_tab_buffers()<CR>
  Map n \[fzf]w :<C-u>call my#plug#fzf#_local_files()<CR>
  Map n \[fzf]C :<C-u>call my#plug#fzf#_xdg_configs()<CR>
  Map n \[fzf]D :<C-u>call my#plug#fzf#_downloads()<CR>
  Map n \[fzf]m :<C-u>call my#plug#fzf#_most_recently_used()<CR>
  Map n \[fzf]l :<C-u>call my#plug#fzf#_lines()<CR>
  Map n \[fzf]g :<C-u>call my#plug#fzf#_git_diff_files()<CR>
  Map n \[fzf]G :<C-u>call my#plug#fzf#_ghq()<CR>
  Map n \[fzf]d :<C-u>call my#plug#fzf#_dotfiles()<CR>
  Map n \[fzf]i :<C-u>call my#plug#fzf#_init_scripts()<CR>
  Map n \[fzf]p :<C-u>call my#plug#fzf#_plugin_confs()<CR>
  Map n \[fzf]P :<C-u>call my#plug#fzf#_plugin_dirs()<CR>
  Map n \[fzf]_r :<C-u>call my#plug#fzf#_runtimepaths()<CR>
  Map n \[fzf]o :<C-u>FZFoutput<Space>
endfunction

let s:fd_available = executable('fd')

let s:bat_preview_opt_normal    = "--preview='bat --plain --color=always --line-range :10000 {}'"
let s:bat_preview_opt_formatted = "--preview='bat --plain --color=always --line-range :10000 {3}'"

function! my#plug#fzf#_without_ignored_files() abort
  let buffiles = my#plug#fzf#tab_buffers#list(tabpagenr())->map('fnameescape(v:val)')
  let src = '_vim_fzf_list_files buffers_and_files ' . join(buffiles, ' ')
  call fzf#run({
    \   'sink*': function('my#plug#fzf#_open_file'),
    \   'source': src,
    \   'up': '45%',
    \   'options': '--header [files] ' . s:bat_preview_opt_formatted,
    \ })
endfunction

function! my#plug#fzf#_open_file(names) abort
  execute 'edit' s:fmt_to_filepath(a:names[0])
endfunction

function! s:fmt_to_filepath(line) abort
  let parts = split(a:line, '\s')
  return fnameescape(parts[2])
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
  let buffiles = my#plug#fzf#tab_buffers#list(tabpagenr())->map('fnameescape(v:val)')
  let src = '_vim_fzf_list_files buffers ' . join(buffiles, ' ')
  call fzf#run({
    \   'sink*': function('my#plug#fzf#_tab_buffers_on_select'),
    \   'source': src,
    \   'up': '45%',
    \   'options': '--multi --expect=ctrl-d --header [buffers] ' . s:bat_preview_opt_formatted
    \ })
endfunction

function! my#plug#fzf#_tab_buffers_on_select(names) abort
  if len(a:names) == 0
    return
  endif
  if a:names[0] == 'ctrl-d'
    for name in a:names[1:]
      execute 'bdelete' s:fmt_to_filepath(name)
    endfor
  else
    execute 'edit' s:fmt_to_filepath(a:names[1])
  endif
endfunction

function! my#plug#fzf#_tab_buffers_normal_path_on_select(names) abort
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
    \   'up': '45%',
    \ })
endfunction

function! my#plug#fzf#_lines() abort
  let scale = len(string(line('$')))
  let lines = map(getline(1, '$'), {idx, v -> printf("% ".scale."d", idx+1) . '| ' . v})

  call fzf#run({
    \   'sink*': funcref('my#plug#fzf#_lines_on_select', [scale]),
    \   'source': lines,
    \   'options': '--multi --reverse --no-sort --expect=ctrl-y',
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

function! my#plug#fzf#_git_diff_files() abort
  let base = get(g:, 'my_git_diff_base', 'HEAD')
  let buffiles = my#plug#fzf#tab_buffers#list(tabpagenr())->map('fnameescape(v:val)')
  let src = '_vim_fzf_list_files git_diff_files ' . base . ' ' . join(buffiles, ' ')
  call fzf#run({
    \   'sink*': function('my#plug#fzf#_open_file'),
    \   'source': src,
    \   'up': '45%',
    \   'options': '--no-sort --header "[git diff ' . base . ']" ' . s:bat_preview_opt_formatted,
    \ })
endfunction

function! my#plug#fzf#_ghq() abort
  call fzf#run({
    \   'sink': 'cd',
    \   'source': 'ghq list -p',
    \   'up': '45%',
    \ })
endfunction

function! my#plug#fzf#_local_files() abort
  call fzf#run({
    \   'sink*': function('my#plug#fzf#_open_file'),
    \   'source': '_vim_fzf_list_files fd_formatted',
    \   'dir': '.local',
    \   'up': '45%',
    \   'options': '--header [.local] ' . s:bat_preview_opt_formatted,
    \ })
endfunction

function! my#plug#fzf#_downloads() abort
  call fzf#run({
    \   'sink*': function('my#plug#fzf#_open_file'),
    \   'source': '_vim_fzf_list_files fd_formatted',
    \   'dir': '~/Downloads',
    \   'up': '45%',
    \   'options': '--header [Downloads] ' . s:bat_preview_opt_formatted,
    \ })
endfunction

function! my#plug#fzf#_xdg_configs() abort
  call fzf#run({
    \   'sink*': function('my#plug#fzf#_open_file'),
    \   'source': "_vim_fzf_list_files fd_formatted -E '.android/*'",
    \   'dir': '~/.config',
    \   'up': '45%',
    \   'options': '--header [Downloads] ' . s:bat_preview_opt_formatted,
    \ })
endfunction

function! my#plug#fzf#_most_recently_used() abort
  call fzf#run({
    \   'sink': 'edit',
    \   'source': v:oldfiles,
    \   'up': '45%',
    \ })
endfunction

function! my#plug#fzf#_dotfiles() abort
  call fzf#run({
    \   'sink*': function('my#plug#fzf#_open_file'),
    \   'source': '_vim_fzf_list_files fd_formatted',
    \   'dir': '~/.dotfiles',
    \   'up': '45%',
    \   'options': '--header [dotfiles] ' . s:bat_preview_opt_formatted,
    \ })
endfunction

function! my#plug#fzf#_plugin_confs() abort
  let src = s:fd_available ? 'fd --type f' : ''
  call fzf#run({
    \   'sink': 'edit',
    \   'source': src,
    \   'dir': $MYVIMDIR . '/autoload/my/plug',
    \   'up': '45%',
    \   'options': s:bat_preview_opt_normal,
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
    \   'up': '45%',
    \ })
endfunction

function! my#plug#fzf#_plugin_dirs() abort
  let packdir = $MYVIMDIR . '/pack/'
  call fzf#run({
    \   'sink': funcref('my#plug#fzf#_open_file_or_dir', [packdir]),
    \   'source': 'gits ' . packdir,
    \   'up': '45%',
    \ })
endfunction

function! my#plug#fzf#_runtimepaths() abort
  let paths = split(&runtimepath, ',')
  call fzf#run({
    \   'sink': 'cd',
    \   'source': paths,
    \   'up': '45%',
    \ })
endfunction
