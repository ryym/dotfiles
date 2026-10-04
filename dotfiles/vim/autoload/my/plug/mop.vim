function! my#plug#mop#configure(conf) abort
  let a:conf.repo = 'ryym/mop.vim'
  let a:conf.before_load = function('my#plug#mop#before_load')
endfunction

function my#plug#mop#before_load()
  Remap nv <Leader>wm :<C-u>Mop<CR>
endfunction
