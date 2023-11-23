function! my#plug#lsp#configure(conf) abort
  let a:conf.repo = 'prabirshrestha/vim-lsp'
  let a:conf.depends = ['async']
  let a:conf.async.enabled = 0
  let a:conf.after_load = function('my#plug#lsp#after_load')

  " We use builtin LSP in Neovim.
  let a:conf.skip_load = has('nvim')
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
  Map n \[lsp]R ::LspReferences
  Map n \[lsp]? ::LspStatus
  Map n \[lsp]v ::LspImplementation
  Map n \[lsp]V ::LspPeekImplementation
  Map n \[lsp]t ::LspTypeDefinition
  Map n \[lsp]T ::LspPeekTypeDefinition
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
  endif

  " Rust (https://github.com/prabirshrestha/vim-lsp/wiki/Servers-Rust)
  " (For old versions of Rust, you may need to use rls instead of rust-analyzer)
  autocmd User lsp_setup call lsp#register_server({
    \  'name': 'rust',
    \  'cmd': {_info -> ['rustup', 'run', 'stable', 'rust-analyzer']},
    \  'workspace_config': {'rust': {'clippy_preference': 'on'}},
    \  'whitelist': ['rust'],
    \ })
  autocmd FileType rust call s:configure_lsp()

  " Go (https://github.com/prabirshrestha/vim-lsp/wiki/Servers-Go)
  if executable('gopls')
    autocmd User lsp_setup call lsp#register_server({
      \ 'name': 'go',
      \ 'cmd': {_info -> ['gopls']},
      \ 'whitelist': ['go'],
      \ })
    autocmd FileType go call s:configure_lsp()
  endif

  " Scala (https://github.com/prabirshrestha/vim-lsp/wiki/Servers-Scala)
  " metals: https://scalameta.org/metals/
  " cousier: https://get-coursier.io/
  " cs install metals && cs bootstrap metals -o /path/to/metals
  if executable('metals')
    autocmd User lsp_setup call lsp#register_server({
      \  'name': 'scala',
      \  'cmd': {_info -> ['metals']},
      \  'root_uri': {_info -> lsp#utils#path_to_uri(s:find_nearest_dir('build.sbt'))},
      \  'workspace_config': {},
      \  'whitelist': ['scala', 'sbt'],
      \ })
    autocmd FileType scala call s:configure_lsp()
    autocmd BufWritePre *.scala LspDocumentFormatSync
  endif

  " Unofficial Ruby LSP (https://solargraph.org)
  " if executable("solargraph")
  "   autocmd User lsp_setup call lsp#register_server({
  "     \ 'name': 'ruby',
  "     \ 'cmd': {_info -> ['solargraph', 'stdio']},
  "     \ 'whitelist': ['ruby'],
  "     \ })
  "   autocmd FileType ruby call s:configure_lsp()
  " endif

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

  hi LspErrorText ctermfg=167 guifg=#e67e80 guibg=#543a48 gui=italic
  hi LspHintText ctermfg=245 guifg=fg guibg=#4f585e gui=italic
  hi LspWarningText ctermfg=214 guifg=#dbbc7f guibg=#4d4c43 gui=italic
endfunction
