function! my#plug#bclose#configure(conf) abort
  let a:conf.repo = 'rbgrouleff/bclose.vim'
  let a:conf.before_load = function('my#plug#bclose#before_load')
endfunction

function! my#plug#bclose#before_load()
  Map n \[buffer]d ::Bclose
  Map n \[buffer]D ::Bclose!
endfunction
