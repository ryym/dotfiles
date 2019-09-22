function! my#plug#fugitive#configure(conf) abort
  let a:conf.repo = 'tpope/vim-fugitive'
  let a:conf.after_load = function('my#plug#fugitive#after_load')
endfunction

function! my#plug#fugitive#after_load()
  MapNamedKey <Space>g git
  Map nv \[git]g :s:Git
  Map nv \[git]s ::Gstatus
  Map nv \[git]d ::Gdiff
  Map nv \[git]b ::Gblame -w

  " Detect current opened file to enable fugitive.
  call fugitive#detect(expand('#:p'))
endfunction
