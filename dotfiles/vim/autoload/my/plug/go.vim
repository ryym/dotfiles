function! my#plug#go#configure(conf) abort
  let a:conf.repo = 'fatih/vim-go'
  let a:conf.async.detect_startup_file = ['go']
  let a:conf.before_load = function('my#plug#go#before_load')
endfunction

function! my#plug#go#before_load()
  let g:go_fmt_command = "goimports"
  let g:go_highlight_types = 1

  MapNamedKey <Space>G go
  Map n \[go]t ::GoTest
endfunction
