function! my#plug#jsx_pretty#configure(conf) abort
  let a:conf.repo = 'MaxMEllon/vim-jsx-pretty'
  let a:conf.async.detect_startup_file = ['js', 'jsx', 'tsx']
endfunction
