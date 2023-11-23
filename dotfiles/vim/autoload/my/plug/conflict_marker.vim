function! my#plug#conflict_marker#configure(conf) abort
  let a:conf.repo = 'rhysd/conflict-marker.vim'
  let g:conflict_marker_enable_mappings = 0
endfunction
