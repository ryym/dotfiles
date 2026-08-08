function! my#init#mappings#setup() abort
  " https://github.com/ryym/mapping.vim
  call my#init#func#iniplug#load('mapping.vim')

  " Configure mapping.vim.
  let g:mapping_named_key_format = '\[%s]'

  " Define 'mapleader' before all mappings using <Leader>.
  let g:mapleader = "-"
  Map2 nx - <Nop>

  " Use these keys as main leader keys.
  Map2 n m       <Nop>
  Map2 n <Space> <Nop>

  " Invert numbers by <Space> (mainly to type 6 - 9 by left hand).
  " For example we can jump 9 lines upward by typing '<Space>1k'.
  for n in range(1, 9)
    execute 'Map2 nxo <Space>' . n . ' ' . (10 - n)
  endfor

  " Mark and jump.
  Map2 n mm m
  Map2 nxo _  `

  " Easy helping.
  Map2 n <C-h>     :<C-u>help<Space>
  Map2 n <Leader>h :<C-u>vert help<Space>

  " Easy saving and quitting.
  Map2 n <Space>w  :<C-u>update<CR>
  Map2 n <Space>W  :<C-u>update!<CR>
  Map2 n <Space>q  :<C-u>quit<CR>
  Map2 n <Space>Q  :<C-u>quit!<CR>

  " 'C' and 'D' does not contain the linebreak. So 'Y' should not do so too.
  Map2 n Y y$

  " Break lines and Insert spaces in normal mode.
  " Unfortunately some of them works only on gvim.
  Map2 n <C-CR>          o<Esc>
  Map2 n <S-CR>          O<Esc>
  Map2 n <S-Space>       i<Space><Esc>
  Map2 n <Leader><Space> a<Space><Esc>

  " Easy paragraph moving.
  Map2 nvo <C-j> }
  Map2 nvo <C-k> {

  " Misc
  Map2 n <silent> <Leader>c :<C-u>RmTrailingSpaces<CR>
  Map2 n <Leader>d :<C-u>pwd<CR>
  Map2 n zp zMzv

  " Fix the direction of ';', ',', 'n', 'N'.
  " For example ';' key always move to the right regardless of
  " whether the last key is 'f' or 'F'.
  Map2 nxo <expr> f my#init#mappings#map_repeat_keys_and_move_to_occurrence(1, 'f')
  Map2 nxo <expr> F my#init#mappings#map_repeat_keys_and_move_to_occurrence(0, 'F')
  Map2 nxo <expr> t my#init#mappings#map_repeat_keys_and_move_to_occurrence(1, 't')
  Map2 nxo <expr> T my#init#mappings#map_repeat_keys_and_move_to_occurrence(0, 'T')
  Map2 nxo <expr> n my#init#mappings#search_pattern_to_fixed_direction('n', 'N')
  Map2 nxo <expr> N my#init#mappings#search_pattern_to_fixed_direction('N', 'n')

  " Define easy text object aliases.
  call s:map_text_object('d', '"')
  call s:map_text_object('s', "'")
  call s:map_text_object('m', ')')
  call s:map_text_object('n', '}')
  call s:map_text_object('y', '>')

  " Toggle something.
  MapPrefix n co \[toggle]
  Map2 n <silent> \[toggle]h :<C-u>let v:hlsearch = ! v:hlsearch<CR>
  Map2 n \[toggle]S :<C-u>windo setlocal scrollbind! scrollbind?<CR>
  Map2 n \[toggle]i :call my#init#mappings#toggle_indent_width()<CR>
  Map2 n \[toggle]c :call my#init#mappings#toggle_colorschemes()<CR>
  Map2 n \[toggle]* :call my#init#mappings#toggle_comment_continuation()<CR>

  " Prevent one characer deletion from copying the chracter to the clipboard.
  " I rarely want this behavior.
  for lkey in ['s', 'x']
    let ukey = toupper(lkey)
    execute 'Map2 nx' lkey '"_' . lkey
    execute 'Map2 nx' ukey '"_' . ukey
  endfor

  Map2 n <silent> y<C-g> :<C-u>call my#init#mappings#copy_current_file_path(0)<CR>
  Map2 n <silent> y<C-f> :<C-u>call my#init#mappings#copy_current_file_path(1)<CR>

  " Delete text without changing the clipboard.
  " This is handy when you want to keep the content of clipboard over deletions.
  Map2 nx md "_d
  Map2 nx mD "_D
  Map2 nx mc "_c
  Map2 nx mC "_C

  " Grep by various programs.
  MapPrefix n <Space>s \[grep]
  Map2 n <expr> \[grep]s my#init#func#grep#by_current(0)
  Map2 n <expr> \[grep]+ my#init#func#grep#by_current(1)
  Map2 n \[grep]l :<C-u>ShowGreps<CR>
  Map2 n \[grep]g :<C-u>ChangeGrep git<CR>
  Map2 n \[grep]r :<C-u>ChangeGrep rg<CR>
  Map2 n \[grep]v :<C-u>ChangeGrep vim<CR>

  " Quickfix
  Map2 n q <Nop>
  Map2 n qo  :<C-u>cwindow<CR>
  Map2 n qc  :<C-u>cclose<CR>
  Map2 n qj  :<C-u>cnext<CR>
  Map2 n qk  :<C-u>cprevious<CR>
  Map2 n ql  :<C-u>cnfile<CR>
  Map2 n qh  :<C-u>cpfile<CR>
  Map2 n qgg :<C-u>cfirst<CR>
  Map2 n qG  :<C-u>clast<CR>
  Map2 n qn  :<C-u>cnewer<CR>
  Map2 n qp  :<C-u>colder<CR>
  Map2 n q<Enter> <Enter>:cclose<Enter>

  " Use 'Q' to run macros since 'q' is used as a leader key for quickfix.
  Map2 n Q q

  " Buffers
  MapPrefix n <Space>b \[buffer]
  Map2 n \[buffer]a :<C-u>buffer #<CR>
  Map2 n \[buffer]d :<C-u>bdelete<CR>
  Map2 n \[buffer]l :<C-u>ls<CR>
  Map2 n \[buffer]s :<C-u>ls<CR>:buffer<Space>
  Map2 n \[buffer]j :<C-u>execute 'buffer' v:count1<CR>

  " Tabs
  " I rarely use 't' moves but often use tabs so use 't' as a leader key for tabs.
  MapPrefix n t \[tab]
  Map2 n \[tab]n :<C-u>tabnew<CR>
  Map2 n \[tab]h gT
  Map2 n \[tab]l gt
  Map2 n \[tab]H :<C-u>tabmove -1<CR>
  Map2 n \[tab]L :<C-u>tabmove +1<CR>

  if has('nvim')
    Map2 t <C-w> <C-\\><C-n><C-w>
    Map2 n <C-w>tt :<C-u>terminal<CR>
  else
    Map2 n <C-w>tt :<C-u>terminal ++curwin<CR>
  endif

  " Go to normal mode from terminal mode.
  Map2 t <C-w>n <C-\><C-n>
  Map2 t <C-w><C-n> <C-\><C-n>

  call s:map_unified_win_switches()

  " Reselect visual block after indent.
  Map2 x < <gv
  Map2 x > >gv

  " In command line, be like emacs.
  Map2 c <C-a> <Home>
  Map2 c <C-b> <Left>
  Map2 c <C-e> <End>
  Map2 c <C-f> <Right>
  Map2 c <C-n> <Down>
  Map2 c <C-p> <Up>

  " Paste current path by '%%'.
  Map2 c <expr> %% getcmdtype() == ':' ? fnameescape(expand('%:h')) : '%%'

  " Easy cursor moving in insert mode.
  Map2 i <C-j> <Down>
  Map2 i <C-k> <Up>
  Map2 i <C-h> <Left>
  Map2 i <C-l> <Right>
  Map2 i <C-a> <Esc><S-i>
  Map2 i <C-e> <End>

  Map2 i <C-b> <Left>
  Map2 i <C-f> <Right>

  " Unfortunately this does works only on gvim.
  Remap2 i <C-CR> <End><CR>
  Remap2 i <S-CR> <C-o>O

  Remap2 i <S-Tab> <Tab><Tab>

  " When a popup is open, use tab for selecting the choice.
  Map2 i <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"

  " Break undo sequence after these deletions in Insert mode.
  Map2 i <C-w> <C-g>u<C-w>
  Map2 i <C-u> <C-g>u<C-u>

  " Break a line without inserting the comment leader.
  Map2 i <C-]> <C-o>:set formatoptions-=ro<CR><CR><C-o>:set formatoptions+=ro<CR>

  " Better file path completion.
  " TODO: I want to use <C-w> for window switching even in insert mode.
  Map2 i <C-w> <C-r>=my#init#func#completion#files()<CR>

  " Paste text.
  let sys_register = g:is_unix ? '+' : '*'
  execute 'Map2 i <silent> <C-v> <C-o>:set paste<CR><C-r>' . sys_register . '<C-o>:set nopaste<CR>'
  execute 'Map2 c <C-v> <C-r>' . sys_register

  " In some terminal, <C-Space> is recognized as <Nul> which is equivalent to <C-@>.
  " <C-@> inserts the last inserted text (:help ctrl-@). But I rarely use it. On the other hand,
  " I often accidentally type <C-Space> when typing a Space after some keystrokes using Ctrl.
  " So I want Vim to recognize <C-Space> just as <Space>.
  Map2 i <Nul> <Space>
  " In other environments such as gVim or other terminal emulators, <C-Space> is recognized as-is.
  " So map it to <Space> as well.
  Map2 i <C-Space> <Space>

  " Move a cursor line or selected lines up and down.
  Map2 n <M-j> :<C-u>.m +1<CR>
  Map2 n <M-k> :<C-u>.m -2<CR>
  Map2 v <M-j> :'<,'>m '>+1<CR>gv
  Map2 v <M-k> :'<,'>m '<-2<CR>gv

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
  execute 'Map2 ox' 'i' . a:lhs  'i' . a:rhs
  execute 'Map2 ox' 'a' . a:lhs  'a' . a:rhs
endfunction

" Define unified key mappings for window switching for normal mode and terminal mode.
" Note that currently we use <C-w> for 'termwinkey'. This makes difficult to use <C-w>
" (deleting a word) in bash/zsh. Therefore I remapped the <C-t> to <C-w> in my zsh.
function! s:map_unified_win_switches() abort
  " Split equally. This does not open a new buffer.
  Map2 n <C-w>- :<C-u>split<CR>
  Map2 n <C-w>\| :<C-u>vsplit<CR>

  Map2 n <C-w>u :<C-u>split<CR>
  Map2 n <C-w>i :<C-u>vsplit<CR>

  " Split equally from terminal. This always open a new normal buffer.
  Map2 t <C-w>u <C-\><C-n>:call my#init#func#window#split_from_term({})<CR>
  Map2 t <C-w>i <C-\><C-n>:call my#init#func#window#split_from_term({'vert': 1})<CR>

  " Split and open a small new normal buffer.
  Map2 n <C-w>v :<C-u>call my#init#func#window#split_from_buf({'ratio': 0.35})<CR>
  Map2 n <C-w>V :<C-u>call my#init#func#window#split_from_buf({'ratio': 0.35, 'vert': 1})<CR>
  Map2 t <C-w>v <C-\><C-n>:call my#init#func#window#split_from_term({'ratio': 0.35})<CR>
  Map2 t <C-w>V <C-\><C-n>:call my#init#func#window#split_from_term({'ratio': 0.35, 'vert': 1})<CR>

  " Split equally and open a new terminal.
  Map2 n <C-w>tu :<C-u>call my#init#func#window#split_from_buf({'term': 1})<CR>
  Map2 n <C-w>ti :<C-u>call my#init#func#window#split_from_buf({'term': 1, 'vert': 1})<CR>
  Map2 t <C-w>tu <C-\><C-n>:call my#init#func#window#split_from_term({'term': 1})<CR>
  Map2 t <C-w>ti <C-\><C-n>:call my#init#func#window#split_from_term({'term': 1, 'vert': 1})<CR>

  " Split and open a small terminal.
  Map2 t <C-w>tv <C-\><C-n>:call my#init#func#window#split_from_term({'term': 1, 'ratio': 0.35})<CR>
  Map2 t <C-w>tV <C-\><C-n>:call my#init#func#window#split_from_term({'term': 1, 'ratio': 0.35, 'vert': 1})<CR>
  Map2 n <C-w>tv :<C-u>call my#init#func#window#split_from_buf({'term': 1, 'ratio': 0.35})<CR>
  Map2 n <C-w>tV :<C-u>call my#init#func#window#split_from_buf({'term': 1, 'ratio': 0.35, 'vert': 1})<CR>
endfunction

function! my#init#mappings#map_repeat_keys_and_move_to_occurrence(direct_to_right, command)
  if a:direct_to_right
    Map2 nxo ; ;
    Map2 nxo , ,
  else
    Map2 nxo ; ,
    Map2 nxo , ;
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
