function! my#plug#coffee_script#configure(conf) abort
  let a:conf.repo = 'kchmck/vim-coffee-script'
  let a:conf.async.detect_startup_file = ['coffee']
endfunction
