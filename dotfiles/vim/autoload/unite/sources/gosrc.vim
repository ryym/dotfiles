" Unite source for repositories in $GOPATH/src
" This source depends on the `gits` command (https://github.com/ryym/gits).

let s:source = {
  \ 'name' : 'gosrc',
  \ 'description' : 'Jump to repositories under $GOPATH/src',
  \ 'type' : 'directory',
  \ }

function! unite#sources#gosrc#define()
  return executable('gits') ? s:source : {}
endfunction

function! s:source.gather_candidates(args, context)
  let gosrc = expand('$GOPATH/src')
  let repos = split(unite#util#system('gits -p ' . gosrc), "\n")
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
