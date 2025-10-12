function! my#plug#mucomplete#configure(conf) abort
  let a:conf.repo = 'lifepillar/vim-mucomplete'
  let a:conf.before_load = function('my#plug#mucomplete#before_load')
endfunction

function! my#plug#mucomplete#before_load() abort
  let g:mucomplete#no_mappings = 1

  iunmap <tab>
  imap <tab> <plug>(MUcompleteFwd)

  let target_filetypes = ['lua', 'ruby', 'sql', 'vim']
  augroup vimrc
    for ft in target_filetypes
      execute 'autocmd FileType' ft ':MUcompleteAutoOn'
    endfor
  augroup END
endfunction
