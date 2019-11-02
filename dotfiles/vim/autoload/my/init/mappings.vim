function! my#init#mappings#setup() abort
  " https://github.com/ryym/mapping.vim
  call my#init#func#iniplug#load('mapping.vim')

  " Configure mapping.vim.
  call mapping#set_sid(s:SID())
  let g:mapping_named_key_format = '\[%s]'

  " Define 'mapleader' before all mappings usiing <Leader>.
  let mapleader = "-"
  Map nv - <Nop>

  " Use these keys as main leader keys.
  Map n m       <Nop>
  Map n <Space> <Nop>

  " Invert numbers by <Space> (mainly to type 6 - 9 by left hand).
  " For example we can jump 9 lines upward by typing '<Space>1k'.
  for n in range(1, 9)
    execute 'Map nvo <Space>' . n . ' ' . (10 - n)
  endfor

  " Mark and jump.
  Map n mm m
  Map n _  `

  " Easy helping.
  Map n <C-h>     :us:help
  Map n <Leader>h :us:vert help

  " Easy saving and quitting.
  Map n <Space>w  ::update
  Map n <Space>W  ::update!
  Map n <Space>q  ::quit
  Map n <Space>Q  ::quit!

  " 'C' and 'D' does not contain the linebreak. So 'Y' should not do so too.
  Map n Y y$

  " Break lines and Insert spaces in normal mode.
  " Unfortunately some of them works only on gvim.
  Map n <C-CR>          o<Esc>
  Map n <S-CR>          O<Esc>
  Map n <S-Space>       i<Space><Esc>
  Map n <Leader><Space> a<Space><Esc>

  " In US keyboard, typing ':' is so hard.
  Map nv ; :
  Map nv : ;

  " Easy paragraph moving.
  Map nvo <C-j> }
  Map nvo <C-k> {

  " Misc
  Map n (silent) <Leader>c ::RmTrailingSpaces
  Map n <Leader>d ::pwd
  Map n zp zMzv

  " Fix the direction of ';', ',', 'n', 'N'.
  " For example ';' key always move to the right regardless of
  " whether the last key is 'f' or 'F'.
  Map nvo (expr) f <SID>map_repeat_keys_and_move_to_occurrence(1, 'f')
  Map nvo (expr) F <SID>map_repeat_keys_and_move_to_occurrence(0, 'F')
  Map nvo (expr) t <SID>map_repeat_keys_and_move_to_occurrence(1, 't')
  Map nvo (expr) T <SID>map_repeat_keys_and_move_to_occurrence(0, 'T')
  Map nvo (expr) n <SID>search_pattern_to_fixed_direction('n', 'N')
  Map nvo (expr) N <SID>search_pattern_to_fixed_direction('N', 'n')

  " Define easy text object aliases.
  call s:map_text_object('d', '"')
  call s:map_text_object('s', "'")
  call s:map_text_object('m', ')')
  call s:map_text_object('n', '}')
  call s:map_text_object('y', '>')

  " Toggle something.
  MapNamedKey co toggle
  Map n (silent) \[toggle]h ::let v:hlsearch = ! v:hlsearch
  Map n \[toggle]S ::windo setlocal scrollbind! scrollbind?
  Map n \[toggle]i :f:<SID>toggle_indent_width()
  Map n \[toggle]c :f:<SID>toggle_colorschemes()
  Map n \[toggle]* :f:<SID>toggle_comment_continuation()

  " Prevent one characer deletion from copying the chracter to the clipboard.
  " I rarely want this behavior.
  for lkey in ['s', 'x']
    let ukey = toupper(lkey)
    execute 'Map nv' lkey '"_' . lkey
    execute 'Map nv' ukey '"_' . ukey
  endfor

  " Delete text without changing the clipboard.
  " This is handy when you want to keep the content of clipboard over deletions.
  Map nv md "_d
  Map nv mD "_D
  Map nv mc "_c
  Map nv mC "_C

  " Grep by various programs.
  MapNamedKey <Space>s grep
  Map n (expr) \[grep]s my#init#func#grep#by_current(0)
  Map n (expr) \[grep]+ my#init#func#grep#by_current(1)
  Map n \[grep]l ::ShowGreps
  Map n \[grep]a ::ChangeGrep ag
  Map n \[grep]g ::ChangeGrep git
  Map n \[grep]v ::ChangeGrep git

  " Quickfix
  Map n q <Nop>
  Map n qo  ::cwindow
  Map n qc  ::cclose
  Map n qj  ::cnext
  Map n qk  ::cprevious
  Map n ql  ::cnfile
  Map n qh  ::cpfile
  Map n qgg ::cfirst
  Map n qG  ::clast
  Map n qn  ::cnewer
  Map n qp  ::colder

  " Use 'Q' to run macros since 'q' is used as a leader key for quickfix.
  Map n Q q

  " Buffers
  MapNamedKey <Space>b buffer
  Map n \[buffer]a ::buffer #
  Map n \[buffer]d ::bdelete
  Map n \[buffer]l ::ls
  Map n \[buffer]s :us:ls<CR>:buffer
  Map n \[buffer]j ::execute 'buffer' v:count1

  " Tabs
  " I rarely use 't' moves but often use tabs so use 't' as a leader key for tabs.
  MapNamedKey t tab
  Map n \[tab]n ::tabnew
  Map n \[tab]h gT
  Map n \[tab]l gt

  " Reselect visual block after indent.
  Map v < <gv
  Map v > >gv

  " In command line, be like emacs.
  Map c <C-a> <Home>
  Map c <C-b> <Left>
  Map c <C-e> <End>
  Map c <C-f> <Right>
  Map c <C-n> <Down>
  Map c <C-p> <Up>

  " Paste current path by '%%'.
  Map c (expr) %% getcmdtype() == ':' ? expand('%:h') : '%%'

  " Easy cursor moving in insert mode.
  Map i <C-j> <Down>
  Map i <C-k> <Up>
  Map i <C-h> <Left>
  Map i <C-l> <Right>
  Map i <C-a> <Esc><S-i>
  Map i <C-e> <End>

  " Unfortunately this does works only on gvim.
  Remap i <C-CR> <End><CR>
  Remap i <S-CR> <C-o>O

  Remap i <S-Tab> <Tab><Tab>

  " When a popup is open, use tab for selecting the choice.
  Map i (expr) <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"

  " Break undo sequence after these deletions in Insert mode.
  Map i <C-w> <C-g>u<C-w>
  Map i <C-u> <C-g>u<C-u>

  " Break a line without inserting the comment leader.
  Map i <C-]> <C-o>:set formatoptions-=ro<CR><CR><C-o>:set formatoptions+=ro<CR>

  " Better file path completion.
  " TODO: I want to use <C-w> for window switching even in insert mode.
  Map i <C-w> <C-r>=my#init#func#completion#files()<CR>

  " Paste text.
  Map i (silent) <C-v> <C-o>:set paste<CR><C-r>*<C-o>:set nopaste<CR>
  Map c <C-v> <C-r>*

  if !g:is_gui
    " I don't know why but `Ctrl+Space` pastes text in clipboard
    " only when I use Vim on the terminal.
    " This is annoying so just insert a space instead.
    " (ref: http://h-miyako.hatenablog.com/entry/2014/01/20/053327)
    Map i <Nul> <Space>
  endif
endfunction

function! s:SID()
  return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze_SID$')
endfunction

" Change the mapping of text object {rhs} to {lhs}.
function! s:map_text_object(lhs, rhs)
  execute 'Map ox' 'i' . a:lhs  'i' . a:rhs
  execute 'Map ox' 'a' . a:lhs  'a' . a:rhs
endfunction

function! s:map_repeat_keys_and_move_to_occurrence(direct_to_right, command)
  if a:direct_to_right
    Map nvo : ;
    Map nvo , ,
  else
    Map nvo : ,
    Map nvo , ;
  endif
  return a:command
endfunction

function! s:search_pattern_to_fixed_direction(normal_key, reverse_key)
  return v:searchforward ? a:normal_key : a:reverse_key
endfunction

function! s:toggle_indent_width()
  if &tabstop <= 2
    call s:set_indent(4, &expandtab)
    echo 'Medium indent (4)'
  else
    call s:set_indent(2, &expandtab)
    echo 'Short indent (2)'
  endif
endfunction

let s:togglable_colors = ['smyck256', 'hybrid']
function! s:toggle_colorschemes()
  let current = index(s:togglable_colors, g:colors_name)
  let next = (current + 1) % len(s:togglable_colors)
  execute 'colorscheme' s:togglable_colors[next]
endfunction

function! s:toggle_comment_continuation()
  let will_continue = match(&formatoptions, '\v[ro]') != -1
  if will_continue
    set formatoptions -=ro
    echo 'Do not continue comment lines'
  else
    set formatoptions +=ro
    echo 'Continue comment lines'
  endif
endfunction

