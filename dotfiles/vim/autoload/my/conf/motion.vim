function! my#conf#motion#easymotion_hook_source()
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

function! my#conf#motion#incsearch_hook_source()
  Remap nvo /  <Plug>(incsearch-forward)
  Remap nvo ?  <Plug>(incsearch-backward)
  Remap nvo g/ <Plug>(incsearch-stay)
  Remap nvo n  <Plug>(incsearch-nohl-n)
  Remap nvo N  <Plug>(incsearch-nohl-N)
  Remap nvo *  <Plug>(incsearch-nohl-*)
  Remap nvo #  <Plug>(incsearch-nohl-#)
  Remap nvo g* <Plug>(incsearch-nohl-g*)
  Remap nvo g# <Plug>(incsearch-nohl-g#)

  " Leave default search function to search multi byte characters.
  " (https://github.com/haya14busa/incsearch.vim/issues/52)
  Map nvo <Leader>/ /

  let g:incsearch#auto_nohlsearch = 1
  let g:incsearch#consistent_n_direction = 1
  let g:incsearch#magic = '\v'
endfunction

function! my#conf#motion#comfortable_motion_hook_source()
  nnoremap <silent> <C-d> :call comfortable_motion#flick(170)<CR>
  nnoremap <silent> <C-u> :call comfortable_motion#flick(-170)<CR>
  nnoremap <silent> <C-f> :call comfortable_motion#flick(200)<CR>
  nnoremap <silent> <C-b> :call comfortable_motion#flick(-200)<CR>

  let g:comfortable_motion_no_default_key_mappings = 1
  let g:comfortable_motion_friction = 800
endfunction
