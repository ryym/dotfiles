function! my#init#options#setup() abort
  language C
  set helplang =en,ja

  set encoding      =utf-8
  set fileencoding  =utf-8
  set fileencodings =utf-8,cp932

  if exists('&ambiwidth')
    set ambiwidth =double
  endif

  filetype plugin indent on
  syntax on

  " Default tab/space settings.
  set tabstop     =4
  set shiftwidth  =4
  set softtabstop =4
  set expandtab
  set autoindent
  set smartindent

  " Search settings.
  set hlsearch
  set incsearch
  set ignorecase
  set smartcase

  " Avoid highlighting the last search pattern at reloading vimrc.
  nohlsearch

  " Disable file backups.
  set nobackup
  set nowritebackup
  set noswapfile

  if has('persistent_undo')
    if ! isdirectory($VIMLOCAL . '/undo')
      call mkdir($VIMLOCAL . '/undo')
    endif
    set undofile
    set undodir =$VIMLOCAL/undo
  endif

  " Briefly jump to the matching bracket.
  set showmatch
  set matchtime =2
  set matchpairs& matchpairs+=<:>

  " Folds settings.
  set foldmethod =marker
  set foldcolumn =3

  " Do not align window sizes automatically.
  " This makes splitting be more Tmux-like.
  set noequalalways

  set cursorline
  set number
  set relativenumber
  set hidden
  set ruler
  set showcmd
  set showmode
  set autoread
  set nostartofline
  set title
  set wildmenu
  set list
  set listchars   =tab:>\ "
  set backspace   =indent,eol,start
  set linespace   =1
  set mouse       =a
  set clipboard   =unnamed
  set keywordprg  =:help
  set scrolloff   =3
  set textwidth   =0
  set history     =50
  set laststatus  =2
  set cmdheight   =2
  set completeopt =longest,menuone
  set whichwrap   =b,s,<,>,[,]
  set statusline  =%f%m%r%h%w\ -\ [%{(&fenc!=''?&fenc:&enc)}\ %{&ff}\ %Y]\ [%Llines\]\ (%04l,%04v)
  set formatoptions =croql
  set fileignorecase
  set timeoutlen  =1200
  set ttimeoutlen =10 " To eliminate delays on <Esc> in terminal.
  set gdefault

  " Indent counts of leading backslash for line continuations in vim script.
  let g:vim_indent_cont = 2
endfunction
