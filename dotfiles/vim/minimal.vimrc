"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Minimal vimrc
"""""""""""""""""""""""""""""""""""""""""""""""""""""""

set cpoptions-=C | if 0 | endif

" Basic options {{{1

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
syntax on

set cursorline
set number
set relativenumber
set hidden
set ruler
set showcmd
set showmode
set autoread
set nostartofline
set backspace   =indent,eol,start
set clipboard   =unnamed

" Key mappings {{{!

noremap : ;
noremap ; :

nnoremap <Space>ba :<C-u>buffer #<CR>
nnoremap <Space>bd :<C-u>bdelete<CR>
