function! my#plug#viler#configure(conf) abort
  let a:conf.repo = 'ryym/vim-viler'
  let a:conf.after_load = function('my#plug#viler#after_load')
endfunction

function! my#plug#viler#after_load() abort
  " TODO: Remove defx and rename the mapping prefix.
  Map n (silent) \[defx]f ::call viler#open(expand('%:h'), {'do_before': 'vsplit \| vert resize 35'})

  autocmd vimrc FileType viler call <SID>configure_viler_buffer()
endfunction

function! s:configure_viler_buffer() abort
  Remap n (buffer nowait) <C-l> <Plug>(viler-open-file)
  Remap n (buffer nowait) <C-h> <Plug>(viler-cd-up)
  Remap n (buffer nowait) f <Plug>(viler-toggle-tree)
  Remap n (buffer nowait) . <Plug>(viler-toggle-dotfiles)
  Remap n (buffer nowait) L <Plug>(viler-refresh)
endfunction

