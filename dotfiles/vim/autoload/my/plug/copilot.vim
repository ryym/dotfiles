function! my#plug#copilot#configure(conf) abort
  let a:conf.repo = 'github/copilot.vim'
  let g:copilot_filetypes = { '*': v:false }

  " Request a suggestion by Ctrl-*minus* (hyphen).
  Remap i <C-_> <Plug>(copilot-suggest)
endfunction
