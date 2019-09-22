function! my#plug#easymotion#configure(conf) abort
  let a:conf.repo = 'easymotion/vim-easymotion'
  let a:conf.before_load = function('my#plug#easymotion#before_load')
endfunction

function!  my#plug#easymotion#before_load()
  Remap nvo ms <Plug>(easymotion-s2)
  Remap nvo mf <Plug>(easymotion-fl2)
  Remap nvo mF <Plug>(easymotion-Fl2)
  Remap nvo mt <Plug>(easymotion-tl2)
  Remap nvo mT <Plug>(easymotion-Tl2)
  Remap nvo m/ <Plug>(easymotion-fn)
  Remap nvo m? <Plug>(easymotion-Fn)
  Remap nvo m: <Plug>(easymotion-next)
  Remap nvo m, <Plug>(easymotion-prev)

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
