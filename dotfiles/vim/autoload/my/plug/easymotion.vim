function! my#plug#easymotion#configure(conf) abort
  let a:conf.repo = 'easymotion/vim-easymotion'
  let a:conf.before_load = function('my#plug#easymotion#before_load')
endfunction

function!  my#plug#easymotion#before_load()
  Remap nxo ms <Plug>(easymotion-s2)
  Remap nxo mf <Plug>(easymotion-fl2)
  Remap nxo mF <Plug>(easymotion-Fl2)
  Remap nxo mt <Plug>(easymotion-tl2)
  Remap nxo mT <Plug>(easymotion-Tl2)
  Remap nxo m/ <Plug>(easymotion-fn)
  Remap nxo m? <Plug>(easymotion-Fn)
  Remap nxo m: <Plug>(easymotion-next)
  Remap nxo m, <Plug>(easymotion-prev)

  let g:EasyMotion_do_mapping = 0
  let g:EasyMotion_space_jump_first = 1
  let g:EasyMotion_smartcase        = 1
  let g:EasyMotion_use_upper        = 1
  let g:EasyMotion_keys = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'

  highlight link EasyMotionIncSearch    Search
  highlight link EasyMotionTarget       ErrorMsg
  highlight link EasyMotionShade        Comment
  highlight link EasyMotionTarget2First Todo
endfunction
