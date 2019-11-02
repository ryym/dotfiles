function! my#init#func#iniplug#load(name) abort
  execute 'packadd' a:name

  let docdir = $MYVIMDIR . '/pack/init/opt/' . a:name . '/doc'
  if isdirectory(docdir)
    execute 'helptags' docdir
  endif
endfunction
