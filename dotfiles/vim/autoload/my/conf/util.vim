function! my#conf#util#unified_diff_hook_source()
  set diffexpr=unified_diff#diffexpr()

  let unified_diff#executable = 'git'
  let unified_diff#iwhite_arguments = ['--ignore--all-space']
endfunction

function! my#conf#util#fugitive_hook_post_source()
  MapNamedKey <Space>g git
  Map nv \[git]g :s:Git
  Map nv \[git]s ::Gstatus
  Map nv \[git]d ::Gdiff
  Map nv \[git]b ::Gblame -w

  " Detect current opened file to enable fugitive.
  call fugitive#detect(expand('#:p'))
endfunction
