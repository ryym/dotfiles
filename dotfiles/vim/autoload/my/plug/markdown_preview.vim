function! my#plug#markdown_preview#configure(conf) abort
  let a:conf.repo = 'iamcco/markdown-preview.nvim'
  let a:conf.after_load = function('my#plug#markdown_preview#after_load')
endfunction

function! my#plug#markdown_preview#after_load() abort
  let plug_path = plugger#plugin_path('markdown_preview') . '/'

  if !isdirectory(plug_path . 'node_modules')
    execute "cd" plug_path
    echom "Installing dependencies for markdown_preview..."
    call system("yarn install")
    execute "cd -"
  endif
endfunction
