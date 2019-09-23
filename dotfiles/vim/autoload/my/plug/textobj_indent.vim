function! my#plug#textobj_indent#configure(conf) abort
  let a:conf.repo = 'kana/vim-textobj-indent'
  let a:conf.depends = ['textobj_user']
endfunction
