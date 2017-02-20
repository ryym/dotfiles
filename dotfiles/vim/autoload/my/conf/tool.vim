" unified diff {{{1
function! my#conf#tool#unified_diff_hook_source()
  set diffexpr=unified_diff#diffexpr()

  let unified_diff#executable = 'git'
  let unified_diff#iwhite_arguments = ['--ignore--all-space']
endfunction

" fugitive {{{1
function! my#conf#tool#fugitive_hook_post_source()
  MapNamedKey <Space>g git
  Map nv \[git]g :s:Git
  Map nv \[git]s ::Gstatus
  Map nv \[git]d ::Gdiff
  Map nv \[git]b ::Gblame -w

  " Detect current opened file to enable fugitive.
  call fugitive#detect(expand('#:p'))
endfunction

" vimproc {{{1
function! my#conf#tool#hook_post_update()
  if g:is_windows
    let g:dein#plugin.disabled = 1
    return
  endif

  let cmd = ''
  if g:is_mac
    let cmd = 'make -f make_mac.mak'
  elseif executable('gmake')
    let cmd = 'gmake'
  else
    let cmd = 'make'
  endif

  let g:dein#plugin.build = cmd
endfunction

" vimfiler {{{1
function! my#conf#tool#vimfiler_hook_source()
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
