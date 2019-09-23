function! my#plug#emmet#configure(conf) abort
  let a:conf.repo = 'mattn/emmet-vim'
  let a:conf.before_load = function('my#plug#emmet#before_load')
endfunction

function! my#plug#emmet#before_load()
  " https://github.com/mattn/emmet-vim/issues/350
  let g:user_emmet_settings = {
    \  'javascript.jsx' : { 'extends' : 'jsx' },
    \  'typescript' : { 'extends' : 'jsx' },
    \ }
endfunction
