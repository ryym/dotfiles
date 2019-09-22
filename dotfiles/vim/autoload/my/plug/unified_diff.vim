function! my#plug#unified_diff#configure(conf) abort
  let a:conf.repo = 'lambdalisue/vim-unified-diff'
  let a:conf.before_load = function('my#plug#unified_diff#before_load')
endfunction

function! my#plug#unified_diff#before_load()
  set diffexpr=unified_diff#diffexpr()
  let unified_diff#executable = 'git'
  let unified_diff#iwhite_arguments = ['--ignore--all-space']
endfunction
