function! s:map_unite_commands(key, command, end_key)
  execute 'Map n' '\[unite]'   . a:key ':u:' . a:command . a:end_key
  execute 'Map n' '\[uniteNq]' . a:key ':u:' . a:command '-no-quit -winheight=15' . a:end_key
endfunction

function! my#unite#configure()
  MapNamedKey <Space>u unite
  MapNamedKey <Space>U uniteNq

  let s:mappings = [
    \   ['u', 'Unite'                    , '<Space>'],
    \   ['b', 'Unite buffer_tab'         , '<CR>'],
    \   ['f', 'Unite file'               , '<CR>'],
    \   ['r', 'Unite file_rec/async'     , '<CR>'],
    \   ['o', 'Unite'                    , ' output:'],
    \   ['c', 'UniteWithCurrentDir file' , '<CR>'],
    \   ['C', 'UniteWithCurrentDir'      , '<Space>'],
    \   ['d', 'UniteWithBufferDir file'  , '<CR>'],
    \   ['D', 'UniteWithBufferDir'       , '<Space>'],
    \   ['k', 'UniteWithCursorWord line' , '<CR>'],
    \   ['K', 'UniteWithCursorWord'      , '<Space>']
    \ ]

  for [s:key, s:command, s:end_key] in s:mappings
    call <SID>map_unite_commands(s:key, s:command, s:end_key)
  endfor
  unlet s:mappings s:key s:command s:end_key

  " Show dotfiles at :Unite file
  call unite#custom#source('file', 'matchers', 'matcher_default')

  " Don't list up unneccesary files.
  call unite#custom#source('file_rec,file_rec/async',
    \ 'ignore_pattern',
    \ 'node_modules/.*\|bower_components/.*\|*.png\|*.jpg\|*.jpeg\|*.gif')

  call unite#custom#profile('default', 'context', {
    \ 'start_insert': 1
    \ })

  call unite#custom#default_action('directory', 'lcd')

  let g:unite_source_alias_aliases = {
    \ 'f'  : 'file',
    \ 'fr' : 'file_rec',
    \ 'b'  : 'buffer',
    \ 'bt' : 'buffer_tab',
    \ 'g'  : 'grep',
    \ 'l'  : 'line',
    \ 'nb' : 'neobundle',
    \ 'go' : 'gosrc',
    \ }

  if executable('ag')
    let g:unite_source_rec_async_command = ['ag', '--follow', '--nocolor',
      \ '--nogroup', '--hidden', '-g', '']
    let g:unite_source_grep_comand = 'ag'
  endif

  " Key mappings in unite buffers
  autocmd vimrc FileType unite call <SID>map_keys_on_unite()
  function! s:map_keys_on_unite()
    Map n (buffer expr) s unite#smart_map('s', unite#do_action('split'))
    Map n (buffer expr) v unite#smart_map('v', unite#do_action('vsplit'))
    Map n (buffer expr) f unite#smart_map('f', unite#do_action('vimfiler'))

    " For 'buffer' or 'buffer_tab'
    Map n (buffer expr) d unite#smart_map('d', unite#do_action('delete'))
    Map n (buffer expr) w unite#smart_map('w', unite#do_action('wipeout'))
  endfunction
endfunction

function my#unite#configure_neomru()
  call <SID>map_unite_commands('m', 'Unite file_mru', '<CR>')
endfunction

function my#unite#configure_ghq()
  call <SID>map_unite_commands('g', 'Unite ghq', '<CR>')
endfunction
