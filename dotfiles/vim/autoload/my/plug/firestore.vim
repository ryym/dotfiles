function! my#plug#firestore#configure(conf) abort
  let a:conf.repo = 'delphinus/vim-firestore'
  let a:conf.async.detect_startup_file = ['rules']
  let a:conf.after_load = function('my#plug#firestore#after_load')
endfunction

function! my#plug#firestore#after_load() abort
  " I don't know why but commentstring config defined in vim-firestore's ftplugin does not work.
  " https://github.com/delphinus/vim-firestore/blob/e53fe9dc9ece7eb5253c59981e47d116057c0203/ftplugin/firestore.vim
  autocmd FileType firestore setlocal commentstring=\/\/\ %s
endfunction
