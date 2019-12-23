function! my#plug#typescript#configure(conf) abort
  let a:conf.repo = 'leafgarland/typescript-vim'
  let a:conf.async.detect_startup_file = ['ts', 'tsx']
endfunction
