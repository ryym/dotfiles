" Unite source for repositories in `packpath`[0]
" This source depends on the `gits` command (https://github.com/ryym/gits).

let s:source = {
  \ 'name' : 'vimpack',
  \ 'description' : 'Jump to Vim plugin directory in `packpath`',
  \ 'type' : 'directory',
  \ }

function! unite#sources#vimpack#define()
  return executable('gits') ? s:source : {}
endfunction

function! s:source.gather_candidates(args, context)
  let packpath = split(&packpath, ',')[0]
  let repos = split(unite#util#system('gits -p ' . packpath), "\n")
  let candidates = []

  for repo in repos
    call add(candidates, {
      \   'word' : repo,
      \   'kind' : 'directory',
      \   'action__directory': repo
      \ })
  endfor
  return candidates
endfunction
