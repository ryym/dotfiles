function! my#init#autocmds#setup() abort
  augroup vimrc
    autocmd WinEnter * checktime
    autocmd BufReadPost * RestoreCursorPosition

    if has('nvim')
      autocmd TermOpen * call s:setup_terminal_buffer()
    else
      autocmd TerminalOpen * call s:setup_terminal_buffer()
    endif
  augroup END

  call my#init#func#buf#setup_autocmds()

  call s:customize_per_filetype()
  call s:define_filetype_indents()
  call s:setup_enhanced_diff_highlighting()

  " Apply file type settings to the current buffer when vimrc is reloaded.
  if !has('vim_starting')
    doautocmd vimrc FileType
  endif
endfunction

function! s:setup_terminal_buffer() abort
  startinsert

  " Disable these options to keep the window width same between
  " the terminal mode and terminal-normal mode.
  setlocal nonumber
  setlocal norelativenumber
  setlocal foldcolumn=0
endfunction

function! s:customize_per_filetype() abort
  augroup vimrc
    " Groovy local settings
    autocmd FileType groovy setlocal cindent cinoptions& cinoptions+=j1

    " Show line numbers in help files which is off by default.
    autocmd FileType help setlocal number | setlocal relativenumber

    if !has('nvim')
      " Set commentstring correctly for JS and CSS in HTML and Vue files.
      autocmd CursorMoved *.html,*.vue call <SID>adjust_commentstring_in_html()
    endif

    autocmd FileType ocaml setlocal commentstring=(*%s*)
    autocmd FileType gitconfig setlocal commentstring=#%s
    autocmd FileType sql setlocal commentstring=--%s

    " The textwidth is set as 78 by default.
    autocmd FileType vim setlocal textwidth=0

    " Disable colorcolumn for the quickfix list.
    autocmd FileType qf setlocal colorcolumn=

    " Configure filetypes which have to be assigned manually.
    call s:delegate_filetypes({
      \ '*.gradle'     : 'groovy',
      \ 'Jenkinsfile'  : 'groovy',
      \ '*.es6'        : 'javascript',
      \ '.babelrc'     : 'json',
      \ '.pryrc'       : 'ruby',
      \ 'Guardfile'    : 'ruby',
      \ 'Vagrantfile'  : 'ruby',
      \ 'Berksfile'    : 'ruby',
      \ 'Dockerfile*'  : 'Dockerfile',
      \ '*.purs'       : 'haskell',
      \ '*.tsx'        : 'typescript.tsx',
      \ '*.json'       : 'json5',
      \ '*.mdc'       : 'markdown',
      \ })
  augroup END
endfunction

function! s:delegate_filetypes(filetypes)
  for [name_pattern, type] in items(a:filetypes)
    execute 'autocmd BufNewFile,BufRead' name_pattern
      \ 'setlocal filetype='.type
  endfor
endfunction

function! s:adjust_commentstring_in_html()
  let syntaxes = join(my#init#func#syntax#names_at_cursor(), ' ')
  if syntaxes =~ 'html'
    setlocal commentstring=<!--%s-->
  elseif syntaxes =~ 'javaScript'
    setlocal commentstring=//%s
  elseif syntaxes =~ 'css'
    setlocal commentstring=/*%s*/
  else
  endif
endfunction

function! s:define_filetype_indents() abort
  augroup vimrc
    autocmd FileType javascript      ShortIndent
    autocmd FileType typescript      ShortIndent
    autocmd FileType typescript.tsx  ShortIndent
    autocmd FileType coffee          ShortIndent
    autocmd FileType css             ShortIndent
    autocmd FileType scss            ShortIndent
    autocmd FileType sass            ShortIndent
    autocmd FileType haml            ShortIndent
    autocmd FileType yaml            ShortIndent
    autocmd FileType ruby            ShortIndent
    autocmd FileType vim             ShortIndent
    autocmd FileType vimspec         ShortIndent
    autocmd FileType scala           ShortIndent
    autocmd FileType sql             ShortIndent
    autocmd FileType json            ShortIndent
    autocmd FileType html            ShortIndent
    autocmd FileType xhtml           ShortIndent
    autocmd FileType eruby           ShortIndent
    autocmd FileType jsp             ShortIndent
    autocmd FileType vue             ShortIndent
    autocmd FileType terraform       ShortIndent
    autocmd FileType firestore       ShortIndent
    autocmd FileType c               MediumIndent
    autocmd FileType cs              MediumIndent
    autocmd FileType vb              MediumIndent
    autocmd FileType java            MediumIndent
    autocmd FileType groovy          MediumIndent
    autocmd FileType xml             MediumIndent
    autocmd FileType sh              MediumIndent
    autocmd FileType markdown        IndentBy 3 1
    autocmd FileType go              IndentBy 4 0
    autocmd FileType text            IndentBy 4 0
    autocmd FileType help            IndentBy 8 0
  augroup END
endfunction

" Make the left (before) diff window highlight its unique lines as removed,
" and the right (after) window highlight its unique lines as added, like
" most other diff tools do. By default vim highlights both sides the same
" way, so it's hard to tell at a glance which side removed or added lines.
function! s:setup_enhanced_diff_highlighting() abort
  augroup vimrc
    autocmd ColorScheme * call s:define_enhanced_diff_hl_groups()
    autocmd VimEnter * call s:apply_enhanced_diff_hl()
    autocmd OptionSet diff call s:apply_enhanced_diff_hl()
  augroup END
endfunction

function! s:define_enhanced_diff_hl_groups() abort
  " Only copy DiffDelete's background, not its foreground. Many
  " colorschemes fix DiffDelete's foreground color, which would hide
  " syntax highlighting if we linked to it directly.
  call s:link_bg_only('MyDiffAddAsDelete', 'DiffDelete')
  highlight link MyDiffDeleteDim NonText
endfunction

function! s:link_bg_only(name, src) abort
  let id = synIDtrans(hlID(a:src))
  let cterm_bg = synIDattr(id, 'bg', 'cterm')
  let cmd = 'highlight ' . a:name . ' ctermbg=' . (empty(cterm_bg) ? 'NONE' : cterm_bg)
  if has('gui_running') || &termguicolors
    let gui_bg = synIDattr(id, 'bg#')
    let cmd .= ' guibg=' . (empty(gui_bg) ? 'NONE' : gui_bg)
  endif
  execute cmd
endfunction

function! s:apply_enhanced_diff_hl() abort
  let diff_wins = []
  for winnr in range(1, winnr('$'))
    if getwinvar(winnr, '&diff')
      call add(diff_wins, winnr)
    endif
  endfor

  " Only handle the plain 2-way diff case. Window rearrangement (e.g. via
  " `wincmd x`) is not tracked, so the left/right assignment may go stale
  " if windows are swapped after this runs.
  if len(diff_wins) != 2
    return
  endif

  call sort(diff_wins, {a, b -> win_screenpos(a)[1] - win_screenpos(b)[1]})
  let [left, right] = diff_wins

  call setwinvar(left, '&winhighlight', 'DiffAdd:MyDiffAddAsDelete,DiffDelete:MyDiffDeleteDim')
  call setwinvar(right, '&winhighlight', 'DiffDelete:MyDiffDeleteDim')
endfunction
