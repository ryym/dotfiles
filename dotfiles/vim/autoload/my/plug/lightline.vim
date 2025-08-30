function! my#plug#lightline#configure(conf) abort
  let a:conf.repo = 'itchyny/lightline.vim'
  let a:conf.async.enabled = 0
  let a:conf.after_load = function('my#plug#lightline#after_load')
  let a:conf.skip_load = has('nvim')

  let g:lightline = {}
  let g:lightline.colorscheme = 'one'
  let g:lightline.component = { 'filename': '%f' }
endfunction

function! my#plug#lightline#after_load()
  if !has('vim_starting')
    call lightline#update() " Override default statusline when vimrc is reloaded.
  endif
endfunction
