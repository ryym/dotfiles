function! my#plug#prets#configure(conf) abort
  let a:conf.repo = 'ryym/vim-prets'
  let a:conf.depends = ['ale']
  let a:conf.after_load = function('my#plug#prets#after_load')
endfunction

function! my#plug#prets#after_load() abort
  call prets#enable_for([
    \   'javascript',
    \   'javascript.jsx',
    \   'typescript',
    \   'typescript.tsx',
    \   'json',
    \   'css',
    \   'scss',
    \   'html',
    \ ])

  if exists('g:ale_fixers')
    let g:ale_fixers.javascript = [function('prets#ale')]
    let g:ale_fixers.typescript = [function('prets#ale')]
    let g:ale_fixers.scss = [function('prets#ale')]
    let g:ale_fixers.json = [function('prets#ale')]
    let g:ale_fixers.html = [function('prets#ale')]
  endif
endfunction
