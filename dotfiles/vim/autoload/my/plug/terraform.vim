function! my#plug#terraform#configure(conf) abort
  let a:conf.repo = 'hashivim/vim-terraform'
  let a:conf.async.detect_startup_file = ['tf']
  let g:terraform_fmt_on_save=1
  let a:conf.after_load = function('my#plug#terraform#after_load')
endfunction

function! my#plug#terraform#after_load()
  autocmd FileType terraform setlocal commentstring=#%s
endfunction
