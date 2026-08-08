function! my#init#commands#setup() abort
  " Reload and Edit .vimrc.
  command! Rv  source $MYVIMRC | if g:is_gui | source $MYGVIMRC | endif
  command! Ev  edit   $MYVIMRC
  if g:is_gui
    command! Evg edit $MYGVIMRC
  endif

  " Set indent easily.
  command! -nargs=* IndentBy call <SID>set_indent(<f-args>)
  command! ShortIndent  IndentBy 2 1
  command! MediumIndent IndentBy 4 1

  " Run operation for all files in Quickfix list.
  command! -nargs=+ QfDo call <SID>quickfix_do(<q-args>)

  " Restore the last cursor poistion.
  command! RestoreCursorPosition call <SID>restore_cursor_position()

  " Capture command outputs.
  command! -nargs=+ -complete=command Capture call <SID>capture_output_of(<q-args>)

  " Toggle window diffs.
  command! Windiff call <SID>toggle_win_diff(&diff)

  " Print syntax names at the current cursor position.
  command! SyntaxNames :echo my#init#func#syntax#names_at_cursor()

  " Print each path of &runtimepath.
  command! Rtp echo substitute(&runtimepath, ',', '\n', 'g')

  " Remove trailing whitespaces without cursor moving.
  command! RmTrailingSpaces :%s/\v\s+$// | let v:hlsearch = 0 | normal! ``

  " Grep by various programs.
  command! -bang -nargs=+ -complete=file GitGrep call my#init#func#grep#by(0, '<bang>', 'git', <q-args>)
  command! -bang -nargs=+ -complete=file GitGrepAdd call my#init#func#grep#by(1, '<bang>', 'git', <q-args>)
  command! -bang -nargs=+ -complete=file RgGrep call my#init#func#grep#by(0, '<bang>', 'rg', <q-args>)
  command! -bang -nargs=+ -complete=file RgGrepAdd call my#init#func#grep#by(1, '<bang>', 'rg', <q-args>)
  command! -bang -nargs=+ -complete=file VimGrep call my#init#func#grep#by(0, '<bang>', 'vim', <q-args>)
  command! -bang -nargs=+ -complete=file VimGrepAdd call my#init#func#grep#by(1, '<bang>', 'vim', <q-args>)

  command! ShowGreps echo 'Available greps: ' my#init#func#grep#available_greps()
  command! -nargs=1 ChangeGrep call my#init#func#grep#change_grep(<q-args>)

  " Define key mappings for multiple modes at once.
  " e.g. Map nxo <buffer> <silent> j gj
  command! -nargs=+ Map   call <SID>define_mapping('noremap', <f-args>)
  command! -nargs=+ Remap call <SID>define_mapping('map', <f-args>)

  " Map a key to a prefix string so that mappings starting with the
  " prefix can be triggered through it.
  " e.g. MapPrefix n co \[toggle]
  command! -nargs=+ MapPrefix call <SID>define_prefix_mapping(<f-args>)
endfunction

function! s:set_indent(n_space, expand_tab)
  let &l:shiftwidth  = a:n_space
  let &l:tabstop     = a:n_space
  let &l:softtabstop = a:n_space
  let &l:expandtab   = a:expand_tab
endfunction

" Execute the specified command for each buffer in the quickfix list.
" From: http://stackoverflow.com/questions/4792561/how-to-do-search-replace-with-ack-in-vim/4793316#4793316
function! s:quickfix_do(command)
    let buffer_numbers = {}
    for fixlist_entry in getqflist()
      let buffer_numbers[fixlist_entry['bufnr']] = 1
    endfor
    let buffer_number_list = keys(buffer_numbers)

    let current_bufnr = bufnr('%')
    for bufnr in buffer_number_list
      if bufexists(str2nr(bufnr))
        execute 'keepalt buffer' bufnr
        execute a:command
      endif
    endfor
    execute 'keepalt buffer' current_bufnr
endfunction

function! s:restore_cursor_position()
  if line("'\"") > 1 && line("'\"") <= line("$")
    execute 'normal! g`"'
  endif
endfunction

" Capture command outputs.
" If any errors occurred, capture nothing.
function! s:capture_output_of(commands)
  redir => output
  try
    silent execute a:commands
  catch
    echoerr v:exception | return
  finally
    redir END
  endtry

  new
  file `=printf('Output of: [ %s ]', a:commands)`
  setlocal buftype   =nofile
  setlocal bufhidden =delete
  call setline(1, split(output, '\n'))
endfunction

function! s:toggle_win_diff(is_opened)
  if a:is_opened
    diffoff!
  else
    windo diffthis
  endif
endfunction

" Define a key mapping for each mode in `modes`.
" `rest` is passed through as-is, so it can contain any normal
" map-arguments (<buffer>, <expr>, <silent>, ...) and lhs/rhs.
function! s:define_mapping(map_cmd, modes, ...) abort
  let rest    = join(a:000)
  for mode in split(a:modes, '\zs')
    execute mode . a:map_cmd rest
  endfor
endfunction

function! s:define_prefix_mapping(modes, key, prefix) abort
  for mode in split(a:modes, '\zs')
    execute mode . 'noremap' a:prefix '<Nop>'
    execute mode . 'map' a:key a:prefix
  endfor
endfunction
