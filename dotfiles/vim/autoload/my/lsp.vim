function! my#lsp#configure()
  MapNamedKey <Space>v lsp
  Map n \[lsp]d ::LspDocumentDiagnostics
  Map n \[lsp]s ::LspDocumentSymbol
  Map n \[lsp]j ::LspNextError
  Map n \[lsp]k ::LspPreviousError
  Map n \[lsp]r ::LspRename
  Map n \[lsp]? ::LspStatus
  Map n (silent) \[lsp]i ::call my#lsp#_toggle_hover_buffer()

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

function my#lsp#_toggle_hover_buffer() abort
  let bufnr = s:find_hover_bufnr()
  if bufnr == -1
    execute 'LspHover'
  else
    execute 'bdelete ' . bufnr
  endif
endfunction

function s:configure_lsp()
  setlocal omnifunc=lsp#complete
  setlocal signcolumn=yes

  Map n (buffer) <C-]> ::LspDefinition
  Map n (buffer) gd ::LspDefinition
  Map n (buffer) gD ::LspReferences
endfunction

function s:find_hover_bufnr() abort
  for bufnr in tabpagebuflist()
    let ft = getbufvar(bufnr, '&filetype')
    if ft == 'markdown.lsp-hover'
      return bufnr
    endif
  endfor
  return -1
endfunction
