function! my#plug#ale#configure(conf) abort
  let a:conf.repo = 'w0rp/ale'
  let a:conf.before_load = function('my#plug#ale#before_load')
endfunction

function my#plug#ale#before_load()
  let oxfmt_or_prettier = 'my#plug#ale#fix_oxfmt_or_prettier'

  let g:ale_linters_explicit = 1
  let g:ale_fix_on_save = 1
  let g:ale_fixers = {}

  let g:ale_fixers.rust = ['rustfmt']
  let g:ale_fixers.elm = ['elm-format']
  let g:ale_fixers.terraform = ['terraform']
  let g:ale_fixers.go = ['goimports']

  let g:ale_fixers.javascript = [oxfmt_or_prettier]
  let g:ale_fixers.javascriptreact = [oxfmt_or_prettier]
  let g:ale_fixers.typescript = [oxfmt_or_prettier]
  let g:ale_fixers.css = [oxfmt_or_prettier]
  let g:ale_fixers.scss = [oxfmt_or_prettier]
  let g:ale_fixers.json = [oxfmt_or_prettier]
  let g:ale_fixers.jsonc = [oxfmt_or_prettier]
  let g:ale_fixers.json5 = [oxfmt_or_prettier]
  let g:ale_fixers.html = [oxfmt_or_prettier]
  let g:ale_fixers.astro = [oxfmt_or_prettier]
  let g:ale_fixers.graphql = [oxfmt_or_prettier]
  let g:ale_fixers.markdown = [oxfmt_or_prettier]

  let g:ale_rust_rustfmt_options = '--edition 2024'

  MapPrefix n <Leader>a \[ale]
  Map n \[ale]f :<C-u>ALEFix<CR>
endfunction

" Config file names that mark a project as using Oxfmt.
" https://oxc.rs/docs/guide/usage/formatter/config.html
let s:oxfmt_config_files = ['.oxfmtrc.json', '.oxfmtrc.jsonc', 'oxfmt.config.ts', 'oxfmt.config.mts']

" Format with Oxfmt if the project has its config file, otherwise with Prettier.
function my#plug#ale#fix_oxfmt_or_prettier(buffer) abort
  " Look up any Oxfmt config file from the buffer's directory.
  let l:config = ''
  for l:name in s:oxfmt_config_files
    let l:config = ale#path#FindNearestFile(a:buffer, l:name)
    if !empty(l:config)
      break
    endif
  endfor

  " If no config is found, fall back to Prettier.
  if empty(l:config)
    return ale#fixers#prettier#Fix(a:buffer)
  endif

  " Give up formatting if no Oxfmt executable is found.
  let l:executable = s:oxfmt_executable(a:buffer)
  if empty(l:executable)
    return 0
  endif

  " Specify the command. No --config is needed: Oxfmt resolves it from --stdin-filepath.
  return {
    \ 'command': ale#Escape(l:executable) . ' --stdin-filepath %s',
    \ }
endfunction

function s:oxfmt_executable(buffer) abort
  " Prefer the one installed in the project, then a globally installed one.
  " Never fall back to npx, which may install an arbitrary version on the fly.
  let l:local = ale#path#FindNearestFile(a:buffer, 'node_modules/.bin/oxfmt')
  if !empty(l:local)
    return l:local
  endif
  return executable('oxfmt') ? 'oxfmt' : ''
endfunction
