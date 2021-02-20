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

  call s:customize_per_filetype()
  call s:define_filetype_indents()

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

    " Show relative line numbers in help files.
    autocmd FileType help setlocal relativenumber

    " Set commentstring correctly for JS and CSS in HTML and Vue files.
    autocmd CursorMoved *.html,*.vue call <SID>adjust_commentstring_in_html()

    autocmd FileType ocaml setlocal commentstring=(*%s*)

    " The textwidth is set as 78 by default.
    autocmd FileType vim setlocal textwidth=0

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
      \ '*.css'        : 'scss',
      \ '*.tsx'        : 'typescript.tsx',
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
    autocmd FileType typescript      ShortIndent
    autocmd FileType typescript.tsx  ShortIndent
    autocmd FileType c               MediumIndent
    autocmd FileType cs              MediumIndent
    autocmd FileType vb              MediumIndent
    autocmd FileType java            MediumIndent
    autocmd FileType groovy          MediumIndent
    autocmd FileType xml             MediumIndent
    autocmd FileType sh              MediumIndent
    autocmd FileType markdown        MediumIndent
    autocmd FileType go              IndentBy 4 0
    autocmd FileType text            IndentBy 4 0
    autocmd FileType help            IndentBy 8 0
  augroup END
endfunction
