function! my#plug#fugitive#configure(conf) abort
  let a:conf.repo = 'tpope/vim-fugitive'
  let a:conf.after_load = function('my#plug#fugitive#after_load')
  let g:fugitive_no_maps = 1
endfunction

function! my#plug#fugitive#after_load()
  MapPrefix n <Space>g \[git]
  Map2 nv \[git]g :Git<Space>
  Map2 nv \[git]b :<C-u>Git blame -w<CR>

  autocmd FileType fugitiveblame call s:configure_blame_buf()
endfunction

function! s:configure_blame_buf() abort
  " Open a PR page which contains a commit your cursor put on.
  Map2 n <buffer> P :<C-u>call my#plug#fugitive#_open_pr(expand("<cword>"))<CR>
endfunction

function! my#plug#fugitive#_open_pr(hash) abort
  call system('whichpr ' . a:hash)
endfunction
