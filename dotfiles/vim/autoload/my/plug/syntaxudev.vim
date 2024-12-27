function! my#plug#syntaxudev#configure(conf) abort
  let a:conf.repo = 'vim-scripts/syntaxudev.vim'
  let a:conf.async.detect_startup_file = ['rules']
endfunction
