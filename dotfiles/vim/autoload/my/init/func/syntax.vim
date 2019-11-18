
function! my#init#func#syntax#names_at_cursor()
  return map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunction


