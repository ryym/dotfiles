function! my#plug#rufo#configure(conf) abort
  let a:conf.repo = 'ruby-formatter/rufo-vim'
  let g:rufo_auto_formatting = 0
endfunction
