function! my#conf#vimfiler#hook_source()
  MapNamedKey <Space>f vimfiler
  Map n \[vimfiler]f :us:VimFiler
  Map n \[vimfiler]s :us:VimFiler -split -winwidth=60
  Map n \[vimfiler]c ::VimFilerCurrentDir
  Map n \[vimfiler]d ::VimFilerBufferDir
  Map n \[vimfiler]e ::VimFilerBufferDir -split -simple -winwidth=35 -no-quit
  Map n \[vimfiler]E :us:VimFiler        -split -simple -winwidth=35 -no-quit

  let g:vimfiler_as_default_explorer  = 1
  let g:vimfiler_safe_mode_by_default = 0

  " Key mappings in vimfiler buffers
  autocmd vimrc FileType vimfiler call <SID>map_keys_on_vimfiler()
  function! s:map_keys_on_vimfiler()
    " TODO: This conflicts with the default mapping '<Space>'(mark file).
    Remap n (buffer) <Space>q <Plug>(vimfiler_exit)

    Remap n (silent buffer expr) Ar vimfiler#do_action('rec')
  endfunction
endfunction
