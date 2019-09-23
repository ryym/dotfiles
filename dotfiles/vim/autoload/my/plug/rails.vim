function! my#plug#rails#configure(conf) abort
  let a:conf.repo = 'tpope/vim-rails'
  let a:conf.async.detect_startup_file = ['rb']
endfunction
