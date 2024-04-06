function! my#plug#typescript#configure(conf) abort
  let a:conf.repo = 'leafgarland/typescript-vim'
  let a:conf.async.detect_startup_file = ['ts', 'tsx']
  let a:conf.after_load = function('my#plug#typescript#after_load')
endfunction

function! my#plug#typescript#after_load()
  autocmd FileType typescript.tsx call s:enable_jsx_tag_jumpings()
endfunction

function! s:enable_jsx_tag_jumpings()
  " Enable to jump between opening/closing tags in TSX files.
  " https://nextvimmer.netlify.app/posts/typescript-matchit/
  let b:match_ignorecase=0
  let b:match_words =
   \  '<:>,' .
   \  '<\@<=!--:-->,'.
   \  '<\@<=?\k\+:?>,'.
   \  '<\@<=\([^ \t>/]\+\)\%(\s\+[^>]*\%([^/]>\|$\)\|>\|$\):<\@<=/\1>,'.
   \  '<\@<=\%([^ \t>/]\+\)\%(\s\+[^/>]*\|$\):/>'
endfunction
