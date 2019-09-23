function! my#plug#indent_guides#configure(conf) abort
  let a:conf.repo = 'nathanaelkane/vim-indent-guides'
  let a:conf.before_load = function('my#plug#indent_guides#before_load')
endfunction

function! my#plug#indent_guides#before_load()
  Remap n \[toggle]g <Plug>IndentGuidesToggle

  let g:indent_guides_start_level = 2
  let g:indent_guides_guide_size  = 1
  let g:indent_guides_exclude_filetypes = ['help', 'man', 'go']
  if g:is_gui
    autocmd vimrc VimEnter * IndentGuidesEnable
  endif
endfunction
