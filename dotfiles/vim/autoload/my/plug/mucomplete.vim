function! my#plug#mucomplete#configure(conf) abort
  let a:conf.repo = 'lifepillar/vim-mucomplete'
  let a:conf.before_load = function('my#plug#mucomplete#before_load')
endfunction

function! my#plug#mucomplete#before_load() abort
  let g:mucomplete#minimum_prefix_length = 3

  let g:mucomplete#no_mappings = 1
  iunmap <tab>
  imap <tab> <plug>(MUcompleteFwd)

  let g:mucomplete#chains = {
    \   'ruby' : {
    \     'default': ['path', 'c-n'],
    \   }
    \ }

  " Enable auto completion for all files unless LSP is attached.
  " It is configured in vim/autoload/my/plug/lspconfig.lua.
endfunction
