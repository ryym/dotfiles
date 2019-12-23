function! my#plug#lsp#configure(conf) abort
  let a:conf.repo = 'prabirshrestha/vim-lsp'
  let a:conf.depends = ['async']
  let a:conf.async.enabled = 0
  let a:conf.after_load = function('my#plug#lsp#after_load')
endfunction

function! my#plug#lsp#after_load()
  let g:lsp_diagnostics_echo_cursor = 1
  let g:lsp_fold_enabled = 0

  MapNamedKey <Space>v lsp
  Map n \[lsp]d ::LspDocumentDiagnostics
  Map n \[lsp]s ::LspDocumentSymbol
  Map n \[lsp]j ::LspNextError
  Map n \[lsp]k ::LspPreviousError
  Map n \[lsp]r ::LspRename
  Map n \[lsp]? ::LspStatus
  Map n (silent) \[lsp]i ::LspHover

  " TypeScript (https://github.com/prabirshrestha/vim-lsp/wiki/Servers-TypeScript)
  if executable('typescript-language-server')
      autocmd User lsp_setup call lsp#register_server({
        \  'name': 'typescript',
        \  'cmd': {_info -> [&shell, &shellcmdflag, 'typescript-language-server --stdio']},
        \  'root_uri': {_info -> lsp#utils#path_to_uri(s:find_nearest_dir('tsconfig.json'))},
        \  'whitelist': ['typescript', 'typescript.tsx'],
        \ })
      autocmd FileType typescript,typescript.tsx call s:configure_lsp()

      autocmd User lsp_setup call lsp#register_server({
        \  'name': 'javascript',
        \  'cmd': {_info -> [&shell, &shellcmdflag, 'typescript-language-server --stdio']},
        \  'root_uri': {_info -> lsp#utils#path_to_uri(s:find_nearest_dir('package.json'))},
        \  'whitelist': ['javascript', 'javascript.jsx'],
        \ })
      autocmd FileType javascript,javascript.tsx call s:configure_lsp()
  else
    echom 'Install typescript-language-server to use LSP for JavaScript/TypeScript.'
  endif

  " Rust (https://github.com/prabirshrestha/vim-lsp/wiki/Servers-Rust)
  if executable('rls')
    autocmd User lsp_setup call lsp#register_server({
      \  'name': 'rust',
      \  'cmd': {_info -> ['rustup', 'run', 'stable', 'rls']},
      \  'workspace_config': {'rust': {'clippy_preference': 'on'}},
      \  'whitelist': ['rust'],
      \ })
    autocmd FileType rust call s:configure_lsp()
  else
    echom 'Install RLS to use LSP for Rust (https://github.com/prabirshrestha/vim-lsp/wiki/Servers-Rust)'
  endif

  " Go (https://github.com/prabirshrestha/vim-lsp/wiki/Servers-Go)
  if executable('gopls')
    autocmd User lsp_setup call lsp#register_server({
      \ 'name': 'go',
      \ 'cmd': {_info -> ['gopls', '-mode', 'stdio']},
      \ 'whitelist': ['go'],
      \ })
    autocmd FileType go call s:configure_lsp()
  else
    echom 'Install gopls to use LSP for Go'
  endif
endfunction

function s:find_nearest_dir(filename)
  return lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), a:filename)
endfunction

function s:configure_lsp()
  setlocal omnifunc=lsp#complete
  setlocal signcolumn=yes

  Map n (buffer) <C-]> ::LspDefinition
  Map n (buffer) gd ::LspDefinition
  Map n (buffer) gD ::LspReferences
  Map n (buffer) gD ::LspReferences
  Map n (buffer) K ::LspHover
endfunction
