function! my#init#options#setup() abort
  set helplang =en,ja

  set encoding      =utf-8
  set fileencoding  =utf-8
  set fileencodings =utf-8,cp932

  if exists('&ambiwidth')
    " When ambiwidth is set to double, ambiguous width characters such as U+2500 ─ are
    " shown incorrectly in terminal in Vim, in some environments. For example,
    " GNOME terminal displays anbiguous width caracters in single (narrow) width by default.
    " We can change the terminal behavior but tmux always use a single width.
    " Therefore using single width is a simple solution for now.
    " (ref: https://qiita.com/s417-lama/items/b38089a42fe7d4a061da)
    set ambiwidth =single
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
    " Use the different directory in Neovim becasue the undo file format is incompatible.
    let undo_dir = has('nvim') ? '/undo-nvim' : '/undo'
    let $VIMUNDODIR = expand($VIMLOCAL . undo_dir)
    if !isdirectory($VIMUNDODIR)
      call mkdir($VIMUNDODIR)
    endif
    set undofile
    set undodir =$VIMUNDODIR
  endif

  " Briefly jump to the matching bracket.
  set showmatch
  set matchtime =2
  set matchpairs& matchpairs+=<:>

  " Folds settings.
  set foldmethod =marker

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
  set wildmenu
  set list
  set listchars   =tab:>\ "
  set backspace   =indent,eol,start
  set linespace   =1
  set mouse       =a
  set clipboard   =unnamedplus
  set keywordprg  =:help
  set scrolloff   =3
  set textwidth   =0
  set history     =50
  set laststatus  =2
  set cmdheight   =2
  set completeopt =longest,menuone,noselect
  set complete    =.,w,b,u,t,i
  set whichwrap   =b,s,<,>,[,]
  set statusline  =%f%m%r%h%w\ -\ [%{(&fenc!=''?&fenc:&enc)}\ %{&ff}\ %Y]\ [%Llines\]\ (%04l,%04v)
  set shortmess   =Ic
  set formatoptions =croqlj
  set fileignorecase
  set timeoutlen  =1200
  set ttimeoutlen =10 " To eliminate delays on <Esc> in terminal.
  set gdefault
  set signcolumn  =yes
  set grepformat  =%f:%l:%c:%m,%f:%l:%m

  if $COLORTERM == 'truecolor'
    set termguicolors
  endif

  " Indent counts of leading backslash for line continuations in vim script.
  let g:vim_indent_cont = 2
endfunction
