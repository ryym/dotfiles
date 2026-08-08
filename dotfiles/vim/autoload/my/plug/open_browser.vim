function! my#plug#open_browser#configure(conf) abort
  let a:conf.repo = 'tyru/open-browser.vim'
  let a:conf.after_load = function('my#plug#open_browser#before_load')
endfunction

function! my#plug#open_browser#before_load()
  Remap nv <Leader>wo <Plug>(openbrowser-open)
  Remap nv <Leader>ws <Plug>(openbrowser-search)
endfunction
