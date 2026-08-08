function! my#plug#viler#configure(conf) abort
  let a:conf.repo = 'ryym/vim-viler'
  let a:conf.after_load = function('my#plug#viler#after_load')
  let a:conf.async.enabled = 0
endfunction

function! my#plug#viler#after_load() abort
  MapPrefix n <Space>f \[viler]

  Map n <silent> \[viler]f :<C-u>call viler#open(expand('%:h'), {'do_before': 'vsplit \| vert resize 35' })<CR>
  Map n <silent> \[viler]e :<C-u>call viler#open(expand('%:h'))<CR>

  autocmd vimrc FileType viler call s:configure_viler_buffer()
endfunction

function! s:configure_viler_buffer() abort
  Map n <buffer> <nowait> <CR> :<C-u>call viler#open_cursor_file('edit')<CR>
  Remap n <buffer> <nowait> <C-l> <Plug>(viler-open-file)
  Remap n <buffer> <nowait> <C-h> <Plug>(viler-cd-up)
  Remap n <buffer> <nowait> L <Plug>(viler-open-file)
  Remap n <buffer> <nowait> H <Plug>(viler-cd-up)
  Remap n <buffer> <nowait> ' <Plug>(viler-toggle-tree)
  Remap n <buffer> <nowait> T <Plug>(viler-toggle-tree)
  Remap n <buffer> <nowait> . <Plug>(viler-toggle-dotfiles)
  Remap n <buffer> <nowait> R <Plug>(viler-refresh)
endfunction

