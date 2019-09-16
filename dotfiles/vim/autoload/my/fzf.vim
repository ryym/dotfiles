" https://github.com/junegunn/fzf/blob/master/README-VIM.md

function! my#fzf#configure()
  MapNamedKey <Space>z fzf

  Map n \[fzf]f ::call fzf#run({'sink': 'edit'})
  Map n \[fzf]z ::call my#fzf#_tabpage_buffers()
  Map n \[fzf]m ::call my#fzf#_most_recently_used()
  Map n \[fzf]l ::call my#fzf#_lines()
  Map n \[fzf]g ::call my#fzf#_ghq()
  Map n \[fzf]G ::call my#fzf#_gosrc()
  Map n \[fzf]o :us:FZFoutput
endfunction

function! my#fzf#_tabpage_buffers() abort
  let bufs = gettabvar(tabpagenr(), 'tabpagebuffer')
  let bufnrs = map(keys(bufs), 'str2nr(v:val, 10)')
  call fzf#run({
    \   'sink': 'edit',
    \   'source': map(filter(bufnrs, 'buflisted(v:val)'), 'bufname(v:val)'),
    \   'up': '~35%',
    \ })
endfunction

command! -nargs=1 FZFoutput call my#fzf#_outputs(<q-args>)
function! my#fzf#_outputs(cmd) abort
  let outputs = split(execute(a:cmd), '\n')
  call fzf#run({
    \   'source': outputs,
    \   'up': '~35%',
    \ })
endfunction

function! my#fzf#_lines() abort
  let scale = len(string(line('$')))
  let lines = map(getline(1, '$'), {idx, v -> printf("% ".scale."d", idx+1) . '| ' . v})
  call fzf#run({
    \   'sink': function('my#fzf#_lines_sink', [scale]),
    \   'source': lines,
    \   'options': '--reverse',
    \ })
endfunction

function! my#fzf#_lines_sink(width, line) abort
  let ln = str2nr(a:line[0:a:width])
  execute ln
endfunction

function! my#fzf#_ghq() abort
  call fzf#run({
    \   'sink': 'cd',
    \   'source': 'ghq list -p',
    \   'up': '~35%',
    \ })
endfunction

function! my#fzf#_gosrc() abort
  call fzf#run({
    \   'sink': 'cd',
    \   'source': 'gits -p $GOPATH/src',
    \   'up': '~35%',
    \ })
endfunction

function! my#fzf#_most_recently_used() abort
  call fzf#run({
    \   'sink': 'edit',
    \   'source': v:oldfiles,
    \   'up': '~35%',
    \ })
endfunction
