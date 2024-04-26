function! my#plug#viler#configure(conf) abort
  let a:conf.repo = 'ryym/vim-viler'
  let a:conf.after_load = function('my#plug#viler#after_load')
  let a:conf.async.enabled = 0
endfunction

function! my#plug#viler#after_load() abort
  MapNamedKey <Space>f viler

  Map n (silent) \[viler]f ::call viler#open(expand('%:h'), {'do_before': 'vsplit \| vert resize 35' })
  Map n (silent) \[viler]e ::call viler#open(expand('%:h'))

  autocmd vimrc FileType viler call s:configure_viler_buffer()
endfunction

function! s:configure_viler_buffer() abort
  Map n (buffer nowait) <CR> ::call viler#open_cursor_file('edit')
  Remap n (buffer nowait) <C-l> <Plug>(viler-open-file)
  Remap n (buffer nowait) <C-h> <Plug>(viler-cd-up)
  Remap n (buffer nowait) t <Plug>(viler-toggle-tree)
  Remap n (buffer nowait) . <Plug>(viler-toggle-dotfiles)
  Remap n (buffer nowait) L <Plug>(viler-refresh)
endfunction

