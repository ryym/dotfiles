function! my#plug#localrc#configure(conf) abort
  let a:conf.repo = 'thinca/vim-localrc'
  let a:conf.after_load = function('my#plug#localrc#after_load')
endfunction

function! my#plug#localrc#after_load() abort
  call localrc#load('.local.vimrc', getcwd())
endfunction
