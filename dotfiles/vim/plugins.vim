"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin configurations
"""""""""""""""""""""""""""""""""""""""""""""""""""""""

let cp_version = my#pack#compatible_vim_version()
if v:version < cp_version
  echom 'You need to upgrade Vim to ' . cp_version . ' to use plugins!'
  finish
endif

try
  call my#pack#init()
catch
  echo v:exception
  finish
endtry

" Configure Plugins {{{

""" Editing

let def = my#pack#add('tpope/vim-commentary')

let def = my#pack#add('tpope/vim-surround')

let def = my#pack#add('cohama/lexima.vim')
function! def.after_load() "{{{
  " For vspec
  call lexima#add_rule({
    \ 'char'        : '<CR>',
    \ 'input_after' : '<CR>end',
    \ 'at'          : '^\s*\%(describe\|it\|context\)\s\+.\+\%#',
    \ 'filetype'    : 'vim'
    \ })
  call lexima#add_rule({
    \ 'char'        : '<CR>',
    \ 'input_after' : '<CR>end',
    \ 'at'          : '^\s*\%(before\|after\)\s*\%#',
    \ 'filetype'    : 'vim'
    \ })

  " Supress auto-closing for folds in vim
  call lexima#add_rule({
    \ 'char'     : '{',
    \ 'input'    : '{',
    \ 'at'       : '{{\%#',
    \ 'delete'   : 2,
    \ 'filetype' : 'vim'
    \ })
  call lexima#add_rule({
    \ 'char'     : '<CR>',
    \ 'input'    : '<CR>',
    \ 'at'       : '{\{3\}\%#',
    \ 'filetype' : 'vim'
    \ })

  " Supress auto-closing of single quotes (lifetimes) in Rust.
  call lexima#add_rule({
    \ 'char'     : "'",
    \ 'filetype' : 'rust'
    \ })
endfunction "}}}

let def = my#pack#add('LeafCage/yankround.vim')
function! def.after_load()
  Remap nx p     <Plug>(yankround-p)
  Remap n  P     <Plug>(yankround-P)
  Remap nx gp    <Plug>(yankround-gp)
  Remap n  gP    <Plug>(yankround-gP)
  Remap n <C-p> <Plug>(yankround-prev)
  Remap n <C-n> <Plug>(yankround-next)
endfunction

let def = my#pack#add('ryym/vim-unimpaired')
function! def.before_load() " {{{
  let g:unimpaired_mapping = {
    \ 'encodings' : 0,
    \ 'excludes'  : {
    \     'nextprevs' : ['n'],
    \     'toggles'   : ['c', 'h', 'i', 's']
    \   }
    \ }
endfunction
function! def.after_load()
  Remap no [d <Plug>unimpairedContextPrevious
  Remap no ]d <Plug>unimpairedContextNext

  call g:Unimpaired_toggle_option_by('t', 'expandtab')
  call g:Unimpaired_toggle_option_by('s', 'scrollbind')
  call g:Unimpaired_toggle_option_by('p', 'spell')
endfunction " }}}

let def = my#pack#add('mattn/emmet-vim')
function! def.before_load()
  " https://github.com/mattn/emmet-vim/issues/350
  let g:user_emmet_settings = {
    \  'javascript.jsx' : { 'extends' : 'jsx' },
    \  'typescript' : { 'extends' : 'jsx' },
    \ }
endfunction

let def = my#pack#add('prettier/vim-prettier')
"{{{
function! def.before_load()
  let info = my#pack#get_info('vim-prettier')
  let plug_path = info.dir . '/'

  if !isdirectory(plug_path . 'node_modules')
    execute "cd" plug_path
    echom "Installing prettier..."
    call system("yarn install")
    execute "cd -"
  endif

  let g:prettier#exec_cmd_async = 1

  command! PrettierEnableAuto call <SID>prettier_toggle_auto_save(1)
  command! PrettierDisableAuto call <SID>prettier_toggle_auto_save(0)
  call s:prettier_toggle_auto_save(1)
endfunction

let s:prettier_auto_save_enabled = 0
function! s:prettier_toggle_auto_save(on) abort
  if a:on && !s:prettier_auto_save_enabled
    let s:prettier_auto_save_enabled = 1
    augroup VimPrettier
      autocmd BufWritePre *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.scss,*.graphql,*.vue,*.html Prettier
    augroup END
  elseif !a:on
    let s:prettier_auto_save_enabled = 0
    augroup VimPrettier
      autocmd!
    augroup END
  endif
endfunction
"}}}

""" Text Object

let def = my#pack#add('kana/vim-textobj-user')

let def = my#pack#add('kana/vim-textobj-entire')

let def = my#pack#add('kana/vim-textobj-indent')

""" Operator

let def = my#pack#add('kana/vim-operator-user')

let def = my#pack#add('kana/vim-operator-replace')
function! def.after_load()
  Remap nvo mr <Plug>(operator-replace)
endfunction

let def = my#pack#add_opt('ryym/operator-camelize.vim')
function! def.after_load()
  Remap  nvo mp <Plug>(operator-to-camel)
  Remap  nvo mP <Plug>(operator-to-pascal)
  Remap  nvo mk <Plug>(operator-to-snake)
endfunction

""" Motion

let def = my#pack#add('easymotion/vim-easymotion')
function! def.before_load() "{{{
  Remap nvo ms <Plug>(easymotion-s2)
  Remap nvo mf <Plug>(easymotion-fl2)
  Remap nvo mF <Plug>(easymotion-Fl2)
  Remap nvo mt <Plug>(easymotion-tl2)
  Remap nvo mT <Plug>(easymotion-Tl2)
  Remap nvo m/ <Plug>(easymotion-fn)
  Remap nvo m? <Plug>(easymotion-Fn)
  Remap nvo m: <Plug>(easymotion-next)
  Remap nvo m, <Plug>(easymotion-prev)

  let g:EasyMotion_do_mapping = 0
  let g:EasyMotion_space_jump_first = 1
  let g:EasyMotion_smartcase        = 1
  let g:EasyMotion_use_upper        = 1
  let g:EasyMotion_keys = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'

  highlight link EasyMotionIncSearch    Search
  highlight link EasyMotionTarget       ErrorMsg
  highlight link EasyMotionShade        Comment
  highlight link EasyMotionTarget2First Todo
endfunction "}}}

let def = my#pack#add('nelstrom/vim-visual-star-search')

let def = my#pack#add('haya14busa/is.vim')

let def = my#pack#add('yuttie/comfortable-motion.vim')
function! def.before_load() "{{{
  Map n (silent) <C-d> :f:comfortable_motion#flick(170)
  Map n (silent) <C-u> :f:comfortable_motion#flick(-170)
  Map n (silent) <C-f> :f:comfortable_motion#flick(200)
  Map n (silent) <C-b> :f:comfortable_motion#flick(-200)

  let g:comfortable_motion_no_default_key_mappings = 1
  let g:comfortable_motion_friction = 800
endfunction "}}}

""" File Type

let def = my#pack#add_opt('PProvost/vim-ps1')

let def = my#pack#add_opt('kchmck/vim-coffee-script')

let def = my#pack#add('bruno-/vim-man')

let def = my#pack#add('fatih/vim-go')
function! def.before_load()
  let g:go_fmt_command = "goimports"
  let g:go_highlight_types = 1

  MapNamedKey <Space>G go
  Map n \[go]t ::GoTest
endfunction

let def = my#pack#add('derekwyatt/vim-scala')

let def = my#pack#add('hail2u/vim-css3-syntax')

let def = my#pack#add('othree/html5.vim')

let def = my#pack#add('mxw/vim-jsx')
function! def.before_load()
  let g:jsx_ext_required = 0
endfunction

let def = my#pack#add_opt('ryym/vim-riot')

let def = my#pack#add_opt('elixir-lang/vim-elixir')

let def = my#pack#add('rust-lang/rust.vim')

let def = my#pack#add('cespare/vim-toml')

let def = my#pack#add('elmcast/elm-vim')
function! def.before_load()
  let g:elm_setup_keybindings = 0
endfunction

let def = my#pack#add_opt('digitaltoad/vim-pug')

let def = my#pack#add('slim-template/vim-slim')

let def = my#pack#add('posva/vim-vue')

let def = my#pack#add('leafgarland/typescript-vim')

let def = my#pack#add('hashivim/vim-terraform')
function! def.after_load()
  autocmd FileType terraform setlocal commentstring=#%s
endfunction

""" UI

let def = my#pack#add('w0ng/vim-hybrid')
function! def.after_load()
  colorscheme hybrid
endfunction

let def = my#pack#add('itchyny/lightline.vim')
function! def.after_load()
  if !has('vim_starting')
    call lightline#update() " Override default statusline when vimrc is reloaded.
  endif
endfunction

let def = my#pack#add('nathanaelkane/vim-indent-guides')
function! def.before_load() "{{{
  Remap n \[toggle]g <Plug>IndentGuidesToggle

  let g:indent_guides_start_level = 2
  let g:indent_guides_guide_size  = 1
  let g:indent_guides_exclude_filetypes = ['help', 'man', 'go']
  if g:is_gui
    autocmd vimrc VimEnter * IndentGuidesEnable
  endif
endfunction "}}}

let def = my#pack#add('LeafCage/foldCC.vim')
function! def.before_load()
  let g:foldCCtext_head = "printf('%s %d: ', repeat(v:folddashes, v:foldlevel), v:foldlevel)"
  let g:foldCCtext_tail = "printf('%d lines ', v:foldend - v:foldstart + 1)"
  set foldtext =FoldCCtext()
endfunction

let def = my#pack#add('itchyny/vim-cursorword')
function! def.after_load()
  augroup vim-cursorword
    autocmd!
    autocmd FileType defx let b:cursorword = 0
  augroup END
endfunction

""" Tools

let def = my#pack#add('kana/vim-tabpagecd')

let def = my#pack#add('Shougo/defx.nvim')
if !has('nvim')
  call my#pack#add('roxma/nvim-yarp')
  call my#pack#add('roxma/vim-hug-neovim-rpc')
endif
let def.after_load = function('my#defx#configure')

let def = my#pack#add('junegunn/fzf')
let def.after_load = function('my#fzf#configure')

let def = my#pack#add('kana/vim-submode')
function! def.before_load() "{{{
  let g:submode_keep_leaving_key = 1
  let g:submode_timeout          = 0
  let g:submode_timeoutlen       = 3000
endfunction
function! def.after_load()
  call my#submode#wrap()

  SbmDefine scroll
  SbmScrollEnter n <Leader>s
  SbmScroll n <r> u <C-u>
  SbmScroll n <r> d <C-d>
  SbmScroll n <r> f <C-f>
  SbmScroll n <r> b <C-b>
  SbmScroll n j     2<C-e>j
  SbmScroll n k     2<C-y>k
  SbmScroll n J     4<C-e>j
  SbmScroll n K     4<C-y>k
  SbmScroll n <C-j> 6<C-e>j
  SbmScroll n <C-k> 6<C-y>k

  SbmDefine winRes
  SbmWinResEnter n <C-w>m
  SbmWinResEnter n <C-w><C-m>

  " 'L'ower, 'H'eighten, 'S'horten, 'W'iden
  for [s:k, s:command] in items({
    \ 'l': '<C-w>-',
    \ 'h': '<C-w>+',
    \ 's': '<C-w><',
    \ 'w': '<C-w>>'
    \ })
    execute 'SbmWinRes n' s:k               1 . s:command
    execute 'SbmWinRes n' toupper(s:k)      3 . s:command
    execute 'SbmWinRes n' '<C-' . s:k . '>' 5 . s:command
  endfor
  unlet s:k s:command

  SbmDefine tab
  SbmTabEnter n tt
  SbmTab n l gt
  SbmTab n h gT
endfunction "}}}

let def = my#pack#add('tpope/vim-repeat')

let def = my#pack#add('editorconfig/editorconfig-vim')

let def = my#pack#add('rbgrouleff/bclose.vim')
function! def.before_load()
  Map n \[buffer]d ::Bclose
  Map n \[buffer]D ::Bclose!
endfunction

let def = my#pack#add('thinca/vim-localrc')

let def = my#pack#add('kannokanno/previm')

let def = my#pack#add('tyru/open-browser.vim')
function! def.before_load()
  Remap nv <Leader>wo <Plug>(openbrowser-open)
  Remap nv <Leader>ws <Plug>(openbrowser-search)
endfunction

if g:is_mac
  let def = my#pack#add_opt('ryym/macspeech.vim')
  function! def.before_load()
    let g:macspeech_voice = 'Ava'
    Map v  <Leader><Leader>q :r:MacSpeechSelected
    Map nv <Leader><Leader>Q ::MacSpeechStop
  endfunction
endif

let def = my#pack#add('lambdalisue/vim-unified-diff')
function! def.before_load()
  set diffexpr=unified_diff#diffexpr()
  let unified_diff#executable = 'git'
  let unified_diff#iwhite_arguments = ['--ignore--all-space']
endfunction

let def = my#pack#add('tpope/vim-fugitive')
function! def.after_load() "{{{
  MapNamedKey <Space>g git
  Map nv \[git]g :s:Git
  Map nv \[git]s ::Gstatus
  Map nv \[git]d ::Gdiff
  Map nv \[git]b ::Gblame -w

  " Detect current opened file to enable fugitive.
  call fugitive#detect(expand('#:p'))
endfunction "}}}

let def = my#pack#add('tpope/vim-rails')

let def = my#pack#add('gre/play2vim')

let def = my#pack#add_opt('thinca/vim-themis')

let def = my#pack#add_opt('kana/vim-vspec')

let def = my#pack#add('Shougo/tabpagebuffer.vim')

let def = my#pack#add('ryym/bufswitcher.vim')
function def.before_load()
  let g:bufswitcher_configs = { 'per_tab': 1 }
endfunction
function def.after_load()
  SbmDefine bufswitch
  SbmBufswitchEnter n r <Space>bb <Plug>(bufswitcher-show)
  SbmBufswitch n <r> l <Plug>(bufswitcher-next)
  SbmBufswitch n <r> h <Plug>(bufswitcher-prev)
  for i in [1, 2, 3, 4, 5, 6]
    call submode#map('bufswitch', 'n', '', i, ':BufswitcherSwitchTo ' . i . '<CR>')
  endfor

  Map n \[buffer]3 ::BufswitcherSwitchTo 3
endfunction

let def = my#pack#add_opt('qpkorr/vim-renamer')

let def = my#pack#add('w0rp/ale')
function def.before_load()
  let g:ale_linters_explicit = 1
  let g:ale_fix_on_save = 1
  let g:ale_fixers = {
    \ 'rust': ['rustfmt'],
    \ 'elm': ['elm-format'],
    \ 'terraform': ['terraform'],
    \ }
endfunction

" }}}

" Note that we don't install not installed packages automatically.
" For now we need to call 'my#pack#install_new()' manually.
call my#pack#load_all()
call my#pack#warn_if_new_packs_exist()
