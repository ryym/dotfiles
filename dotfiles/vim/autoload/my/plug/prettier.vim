function! my#plug#prettier#configure(conf) abort
  " Use vim-prets experimentally as an alternative for a while.
  let a:conf.skip_load = 1

  let a:conf.repo = 'prettier/vim-prettier'
  let a:conf.before_load = function('my#plug#prettier#before_load')
endfunction

function! my#plug#prettier#before_load()
  let plug_path = plugger#plugin_path('prettier') . '/'

  if !isdirectory(plug_path . 'node_modules')
    execute "cd" plug_path
    echom "Installing prettier..."
    call system("yarn install")
    execute "cd -"
  endif

  let g:prettier#exec_cmd_async = 1

  command! PrettierEnableAuto call s:toggle_auto_save(1)
  command! PrettierDisableAuto call s:toggle_auto_save(0)
  call s:toggle_auto_save(1)
endfunction

let s:prettier_auto_save_enabled = 0

function! s:toggle_auto_save(on) abort
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
