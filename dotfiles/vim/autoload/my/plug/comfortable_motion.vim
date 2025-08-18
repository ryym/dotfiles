function! my#plug#comfortable_motion#configure(conf) abort
  let a:conf.repo = 'yuttie/comfortable-motion.vim'
  let a:conf.before_load = function('my#plug#comfortable_motion#before_load')
endfunction

function! my#plug#comfortable_motion#before_load()
  Map n (silent) <C-d> :f:comfortable_motion#flick(170)
  Map n (silent) <C-u> :f:comfortable_motion#flick(-170)
  Map n (silent) <C-f> :f:comfortable_motion#flick(200)
  Map n (silent) <C-b> :f:comfortable_motion#flick(-200)

  " Remap some keys to ensure consistent behavior across applications.
  " See ryym/dotfiles/sync/os/arch/README.md#key-binding-strategy for details.
  Map n (silent) <Right> :f:comfortable_motion#flick(200)
  Map n (silent) <Left> :f:comfortable_motion#flick(-200)

  let g:comfortable_motion_no_default_key_mappings = 1
  let g:comfortable_motion_friction = 800
endfunction
