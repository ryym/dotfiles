function! my#conf#ui#indent_guides_hook_source()
  Remap n \[toggle]g <Plug>IndentGuidesToggle

  let g:indent_guides_start_level = 2
  let g:indent_guides_guide_size  = 1
  let g:indent_guides_exclude_filetypes = ['help', 'man']
  if g:is_gui
    autocmd vimrc VimEnter * IndentGuidesEnable
  endif
endfunction
