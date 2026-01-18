function! my#plug#fugitive#configure(conf) abort
  let a:conf.repo = 'tpope/vim-fugitive'
  let a:conf.after_load = function('my#plug#fugitive#after_load')
  let g:fugitive_no_maps = 1
endfunction

function! my#plug#fugitive#after_load()
  MapNamedKey <Space>g git
  Map nv \[git]g :s:Git
  Map nv \[git]b ::Git blame -w

  autocmd FileType fugitiveblame call s:configure_blame_buf()
endfunction

function! s:configure_blame_buf() abort
  " Open a PR page which contains a commit your cursor put on.
  Map n (buffer) P ::call my#plug#fugitive#_open_pr(expand("<cword>"))
endfunction

function! my#plug#fugitive#_open_pr(hash) abort
  call system('whichpr open ' . a:hash)
endfunction
