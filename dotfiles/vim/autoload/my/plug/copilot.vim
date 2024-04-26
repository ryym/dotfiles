function! my#plug#copilot#configure(conf) abort
  let a:conf.repo = 'github/copilot.vim'
  " let g:copilot_filetypes = { '*': v:false, 'ruby': v:true, 'typescript': v:true, 'typescript.tsx': v:true }
  let g:copilot_filetypes = { '*': v:false }
  let g:copilot_no_tab_map = v:true

  " Request a suggestion by Ctrl-*minus* (hyphen).
  Remap i <C-_> <Plug>(copilot-suggest)
endfunction
