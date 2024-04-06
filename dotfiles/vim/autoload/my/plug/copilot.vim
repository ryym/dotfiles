function! my#plug#copilot#configure(conf) abort
  let a:conf.repo = 'github/copilot.vim'
  let g:copilot_filetypes = { '*': v:false, 'ruby': v:true, 'typescript': v:true, 'typescript.tsx': v:true }
endfunction
