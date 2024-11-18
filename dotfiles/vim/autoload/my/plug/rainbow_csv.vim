function! my#plug#rainbow_csv#configure(conf) abort
  let a:conf.repo = 'mechatroner/rainbow_csv'
  let a:conf.async.detect_startup_file = ['csv', 'tsv']
endfunction
