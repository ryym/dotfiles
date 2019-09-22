function! my#plug#textobj_entire#configure(conf) abort
  let a:conf.repo = 'kana/vim-textobj-entire'
  let a:conf.depends = ['textobj_user']
endfunction
