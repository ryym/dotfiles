function! my#init#mappings#setup() abort
  " Define 'mapleader' before all mappings using <Leader>.
  let g:mapleader = "-"
  Map nx - <Nop>

  " Use these keys as main leader keys.
  Map n m       <Nop>
  Map n <Space> <Nop>

  " Invert numbers by <Space> (mainly to type 6 - 9 by left hand).
  " For example we can jump 9 lines upward by typing '<Space>1k'.
  for n in range(1, 9)
    execute 'Map nxo <Space>' . n . ' ' . (10 - n)
  endfor

  " Mark and jump.
  Map n mm m
  Map nxo _  `

  " Easy helping.
  Map n <C-h>     :<C-u>help<Space>
  Map n <Leader>h :<C-u>vert help<Space>

  " Easy saving and quitting.
  Map n <Space>w  :<C-u>update<CR>
  Map n <Space>W  :<C-u>update!<CR>
  Map n <Space>q  :<C-u>quit<CR>
  Map n <Space>Q  :<C-u>quit!<CR>

  " 'C' and 'D' does not contain the linebreak. So 'Y' should not do so too.
  Map n Y y$

  " Break lines and Insert spaces in normal mode.
  " Unfortunately some of them works only on gvim.
  Map n <C-CR>          o<Esc>
  Map n <S-CR>          O<Esc>
  Map n <S-Space>       i<Space><Esc>
  Map n <Leader><Space> a<Space><Esc>

  " Easy paragraph moving.
  Map nvo <C-j> }
  Map nvo <C-k> {

  " Misc
  Map n <silent> <Leader>c :<C-u>RmTrailingSpaces<CR>
  Map n <Leader>d :<C-u>pwd<CR>
  Map n zp zMzv

  " Fix the direction of ';', ',', 'n', 'N'.
  " For example ';' key always move to the right regardless of
  " whether the last key is 'f' or 'F'.
  Map nxo <expr> f my#init#mappings#map_repeat_keys_and_move_to_occurrence(1, 'f')
  Map nxo <expr> F my#init#mappings#map_repeat_keys_and_move_to_occurrence(0, 'F')
  Map nxo <expr> t my#init#mappings#map_repeat_keys_and_move_to_occurrence(1, 't')
  Map nxo <expr> T my#init#mappings#map_repeat_keys_and_move_to_occurrence(0, 'T')
  Map nxo <expr> n my#init#mappings#search_pattern_to_fixed_direction('n', 'N')
  Map nxo <expr> N my#init#mappings#search_pattern_to_fixed_direction('N', 'n')

  " Define easy text object aliases.
  call s:map_text_object('d', '"')
  call s:map_text_object('s', "'")
  call s:map_text_object('m', ')')
  call s:map_text_object('n', '}')
  call s:map_text_object('y', '>')

  " Toggle something.
  MapPrefix n co \[toggle]
  Map n <silent> \[toggle]h :<C-u>let v:hlsearch = ! v:hlsearch<CR>
  Map n \[toggle]S :<C-u>windo setlocal scrollbind! scrollbind?<CR>
  Map n \[toggle]i :call my#init#mappings#toggle_indent_width()<CR>
  Map n \[toggle]c :call my#init#mappings#toggle_colorschemes()<CR>
  Map n \[toggle]* :call my#init#mappings#toggle_comment_continuation()<CR>

  " Prevent one characer deletion from copying the chracter to the clipboard.
  " I rarely want this behavior.
  for lkey in ['s', 'x']
    let ukey = toupper(lkey)
    execute 'Map nx' lkey '"_' . lkey
    execute 'Map nx' ukey '"_' . ukey
  endfor

  Map n <silent> y<C-g> :<C-u>call my#init#mappings#copy_current_file_path(0)<CR>
  Map n <silent> y<C-f> :<C-u>call my#init#mappings#copy_current_file_path(1)<CR>

  " Delete text without changing the clipboard.
  " This is handy when you want to keep the content of clipboard over deletions.
  Map nx md "_d
  Map nx mD "_D
  Map nx mc "_c
  Map nx mC "_C

  " Grep by various programs.
  MapPrefix n <Space>s \[grep]
  Map n <expr> \[grep]s my#init#func#grep#by_current(0)
  Map n <expr> \[grep]+ my#init#func#grep#by_current(1)
  Map n \[grep]l :<C-u>ShowGreps<CR>
  Map n \[grep]g :<C-u>ChangeGrep git<CR>
  Map n \[grep]r :<C-u>ChangeGrep rg<CR>
  Map n \[grep]v :<C-u>ChangeGrep vim<CR>

  " Quickfix
  Map n q <Nop>
  Map n qo  :<C-u>cwindow<CR>
  Map n qc  :<C-u>cclose<CR>
  Map n qj  :<C-u>cnext<CR>
  Map n qk  :<C-u>cprevious<CR>
  Map n ql  :<C-u>cnfile<CR>
  Map n qh  :<C-u>cpfile<CR>
  Map n qgg :<C-u>cfirst<CR>
  Map n qG  :<C-u>clast<CR>
  Map n qn  :<C-u>cnewer<CR>
  Map n qp  :<C-u>colder<CR>
  Map n q<Enter> <Enter>:cclose<Enter>

  " Use 'Q' to run macros since 'q' is used as a leader key for quickfix.
  Map n Q q

  " Buffers
  MapPrefix n <Space>b \[buffer]
  Map n \[buffer]a :<C-u>buffer #<CR>
  Map n \[buffer]d :<C-u>bdelete<CR>
  Map n \[buffer]l :<C-u>ls<CR>
  Map n \[buffer]s :<C-u>ls<CR>:buffer<Space>
  Map n \[buffer]j :<C-u>execute 'buffer' v:count1<CR>

  " Tabs
  " I rarely use 't' moves but often use tabs so use 't' as a leader key for tabs.
  MapPrefix n t \[tab]
  Map n \[tab]n :<C-u>tabnew<CR>
  Map n \[tab]h gT
  Map n \[tab]l gt
  Map n \[tab]H :<C-u>tabmove -1<CR>
  Map n \[tab]L :<C-u>tabmove +1<CR>

  if has('nvim')
    Map t <C-w> <C-\\><C-n><C-w>
    Map n <C-w>tt :<C-u>terminal<CR>
  else
    Map n <C-w>tt :<C-u>terminal ++curwin<CR>
  endif

  " Go to normal mode from terminal mode.
  Map t <C-w>n <C-\><C-n>
  Map t <C-w><C-n> <C-\><C-n>

  call s:map_unified_win_switches()

  " Reselect visual block after indent.
  Map x < <gv
  Map x > >gv

  " In command line, be like emacs.
  Map c <C-a> <Home>
  Map c <C-b> <Left>
  Map c <C-e> <End>
  Map c <C-f> <Right>
  Map c <C-n> <Down>
  Map c <C-p> <Up>

  " Paste current path by '%%'.
  Map c <expr> %% getcmdtype() == ':' ? fnameescape(expand('%:h')) : '%%'

  " Easy cursor moving in insert mode.
  Map i <C-j> <Down>
  Map i <C-k> <Up>
  Map i <C-h> <Left>
  Map i <C-l> <Right>
  Map i <C-a> <Esc><S-i>
  Map i <C-e> <End>

  Map i <C-b> <Left>
  Map i <C-f> <Right>

  " Unfortunately this does works only on gvim.
  Remap i <C-CR> <End><CR>
  Remap i <S-CR> <C-o>O

  Remap i <S-Tab> <Tab><Tab>

  " When a popup is open, use tab for selecting the choice.
  Map i <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"

  " Break undo sequence after these deletions in Insert mode.
  Map i <C-w> <C-g>u<C-w>
  Map i <C-u> <C-g>u<C-u>

  " Break a line without inserting the comment leader.
  Map i <C-]> <C-o>:set formatoptions-=ro<CR><CR><C-o>:set formatoptions+=ro<CR>

  " Better file path completion.
  " TODO: I want to use <C-w> for window switching even in insert mode.
  Map i <C-w> <C-r>=my#init#func#completion#files()<CR>

  " Paste text.
  let sys_register = g:is_unix ? '+' : '*'
  execute 'Map i <silent> <C-v> <C-o>:set paste<CR><C-r>' . sys_register . '<C-o>:set nopaste<CR>'
  execute 'Map c <C-v> <C-r>' . sys_register

  " In some terminal, <C-Space> is recognized as <Nul> which is equivalent to <C-@>.
  " <C-@> inserts the last inserted text (:help ctrl-@). But I rarely use it. On the other hand,
  " I often accidentally type <C-Space> when typing a Space after some keystrokes using Ctrl.
  " So I want Vim to recognize <C-Space> just as <Space>.
  Map i <Nul> <Space>
  " In other environments such as gVim or other terminal emulators, <C-Space> is recognized as-is.
  " So map it to <Space> as well.
  Map i <C-Space> <Space>

  " Move a cursor line or selected lines up and down.
  Map n <M-j> :<C-u>.m +1<CR>
  Map n <M-k> :<C-u>.m -2<CR>
  Map v <M-j> :'<,'>m '>+1<CR>gv
  Map v <M-k> :'<,'>m '<-2<CR>gv

  " Used in several Git plugins.
  MapPrefix n <Space>g \[git]

  " Disable default key mappings for man pages since it maps `q` to close Vim
  " but I use `q` as a prefix of quickfix list shortcuts.
  let g:no_man_maps = 1
  " And keep some useful default key bindings.
  " The mapping command is copied from <vim-repo>/runtime/ftplugin/man.vim.
  augroup vimrc
    autocmd FileType man nnoremap <silent> <buffer> gO :lua require'man'.show_toc()<CR>
  augroup END
endfunction

" Change the mapping of text object {rhs} to {lhs}.
function! s:map_text_object(lhs, rhs)
  execute 'Map ox' 'i' . a:lhs  'i' . a:rhs
  execute 'Map ox' 'a' . a:lhs  'a' . a:rhs
endfunction

" Define unified key mappings for window switching for normal mode and terminal mode.
" Note that currently we use <C-w> for 'termwinkey'. This makes difficult to use <C-w>
" (deleting a word) in bash/zsh. Therefore I remapped the <C-t> to <C-w> in my zsh.
function! s:map_unified_win_switches() abort
  " Split equally. This does not open a new buffer.
  Map n <C-w>- :<C-u>split<CR>
  Map n <C-w>\| :<C-u>vsplit<CR>

  Map n <C-w>u :<C-u>split<CR>
  Map n <C-w>i :<C-u>vsplit<CR>

  " Split equally from terminal. This always open a new normal buffer.
  Map t <C-w>u <C-\><C-n>:call my#init#func#window#split_from_term({})<CR>
  Map t <C-w>i <C-\><C-n>:call my#init#func#window#split_from_term({'vert': 1})<CR>

  " Split and open a small new normal buffer.
  Map n <C-w>v :<C-u>call my#init#func#window#split_from_buf({'ratio': 0.35})<CR>
  Map n <C-w>V :<C-u>call my#init#func#window#split_from_buf({'ratio': 0.35, 'vert': 1})<CR>
  Map t <C-w>v <C-\><C-n>:call my#init#func#window#split_from_term({'ratio': 0.35})<CR>
  Map t <C-w>V <C-\><C-n>:call my#init#func#window#split_from_term({'ratio': 0.35, 'vert': 1})<CR>

  " Split equally and open a new terminal.
  Map n <C-w>tu :<C-u>call my#init#func#window#split_from_buf({'term': 1})<CR>
  Map n <C-w>ti :<C-u>call my#init#func#window#split_from_buf({'term': 1, 'vert': 1})<CR>
  Map t <C-w>tu <C-\><C-n>:call my#init#func#window#split_from_term({'term': 1})<CR>
  Map t <C-w>ti <C-\><C-n>:call my#init#func#window#split_from_term({'term': 1, 'vert': 1})<CR>

  " Split and open a small terminal.
  Map t <C-w>tv <C-\><C-n>:call my#init#func#window#split_from_term({'term': 1, 'ratio': 0.35})<CR>
  Map t <C-w>tV <C-\><C-n>:call my#init#func#window#split_from_term({'term': 1, 'ratio': 0.35, 'vert': 1})<CR>
  Map n <C-w>tv :<C-u>call my#init#func#window#split_from_buf({'term': 1, 'ratio': 0.35})<CR>
  Map n <C-w>tV :<C-u>call my#init#func#window#split_from_buf({'term': 1, 'ratio': 0.35, 'vert': 1})<CR>
endfunction

function! my#init#mappings#map_repeat_keys_and_move_to_occurrence(direct_to_right, command)
  if a:direct_to_right
    Map nxo ; ;
    Map nxo , ,
  else
    Map nxo ; ,
    Map nxo , ;
  endif
  return a:command
endfunction

function! my#init#mappings#copy_current_file_path(absolute)
  let path = a:absolute ? expand('%:p') : fnamemodify(expand('%:p'), ':.')
  call setreg(v:register, path)
  echo "Copied: " . path
endfunction

function! my#init#mappings#search_pattern_to_fixed_direction(normal_key, reverse_key)
  return v:searchforward ? a:normal_key : a:reverse_key
endfunction

function! my#init#mappings#toggle_indent_width()
  if &tabstop <= 2
    execute 'IndentBy' 4 &expandtab
    echo 'Medium indent (4)'
  else
    execute 'IndentBy' 2 &expandtab
    echo 'Short indent (2)'
  endif
endfunction

let s:togglable_colors = ['smyck256', 'hybrid']
function! my#init#mappings#toggle_colorschemes()
  let current = index(s:togglable_colors, g:colors_name)
  let next = (current + 1) % len(s:togglable_colors)
  execute 'colorscheme' s:togglable_colors[next]
endfunction

function! my#init#mappings#toggle_comment_continuation()
  let will_continue = match(&formatoptions, '\v[ro]') != -1
  if will_continue
    set formatoptions -=ro
    echo 'Do not continue comment lines'
  else
    set formatoptions +=ro
    echo 'Continue comment lines'
  endif
endfunction
