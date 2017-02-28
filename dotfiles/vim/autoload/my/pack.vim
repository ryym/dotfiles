" My package manager. This is just a wrapper of t-takata's minpac.
" - https://github.com/k-takata/minpac
" - :help packages

let b:packs = {}
let b:new_packs = {}
let b:pack_path = split(&packpath, ',')[0] . '/pack/minpac/'

" Define commands
command! PackInstall call my#pack#install_new()
command! PackLoadAll call my#pack#load_all()

function! my#pack#compatible_vim_version()
  return 800
endfunction

" Install minpac. This is used internally.
function! my#pack#install_minpac() abort
  try
    packadd minpac
  catch
    if g:is_windows
      throw '[pack] Please install k-takata/minpac to use plugins'
    else
      let minpac_repo_url = 'https://github.com/k-takata/minpac.git'
      let minpac_path = expand($MYVIMDIR . '/pack/minpac/opt/minpac')
      echo 'Installing minpac to ' . minpac_path
      call system('git clone ' . minpac_repo_url . ' ' . minpac_path)
      packadd minpac
    endif
  endtry
endfunction

" Initialize my#pack. You need to call this before adding plugins.
function! my#pack#init(...) abort
  call my#pack#install_minpac()

  let options = get(a:, 0)
  if options
    call minpac#init(options)
  else
    call minpac#init()
  endif

  call minpac#add('k-takata/minpac', {'type': 'opt'})
endfunction

" Return information about the specified plugin.
function! my#pack#get_info(name)
  return minpac#getpluginfo(a:name)
endfunction

" Return a dictionary whose keys are not installed plugin names.
function! my#pack#get_new_packs()
  if has_key(b:new_packs, 'packs')
    return b:new_packs.packs
  endif

  let packs = {}
  for name in keys(b:packs)
    let def = b:packs[name]
    let path = b:pack_path . def.type . '/' . name
    if !isdirectory(path)
      let packs[name] = 1
    endif
  endfor

  let b:new_packs.packs = packs
  return packs
endfunction

" Add a 'start' plugin.
" You can register hooks to a returned config object.
" (before_load and after_load)
function! my#pack#add(fullname, ...)
  let options = get(a:, 1, {})
  call minpac#add(a:fullname, options)

  let name = split(a:fullname, '/')[1]
  let type = has_key(options, 'type') && options.type == 'opt' ? 'opt' : 'start'
  let def = { 'options': options, 'type': type }
  let b:packs[name] = def
  return def
endfunction

" Add a 'opt' plugin.
function! my#pack#add_opt(name, ...)
  let options = get(a:, 1, {})
  let options.type = 'opt'
  return my#pack#add(a:name, options)
endfunction

" Install plugins that are defined but not installed yet.
function! my#pack#install_new()
  let new_packs = my#pack#get_new_packs()
  call minpac#update(keys(new_packs))
  call remove(b:new_packs, 'packs')
endfunction

" XXX:
" I want to install not installed packages automatically if possible,
" but I don't know how to wait asynchronous installations. 
function! my#pack#warn_if_new_packs_exist()
  let new_packs = my#pack#get_new_packs()
  if len(new_packs) > 0
    let names = join(keys(new_packs), ', ')
    echom '[pack] There are new packages: ' . names . '.'
    echom '[pack] Run PackInstall and PackLoadAll.'
  endif
endfunction

" Load packages by 'packloadall' with around hooks.
function! my#pack#load_all()
  let new_packs = my#pack#get_new_packs()

  for name in keys(b:packs)
    let def = b:packs[name]
    if has_key(def, 'before_load') && !has_key(new_packs, name)
      call def.before_load()
    endif
  endfor

  " Make sure all packages are sourced. It seems that this command
  " never loads a package in some cases without a bang.
  packloadall!

  for name in keys(b:packs)
    let def = b:packs[name]
    if has_key(def, 'after_load') && !has_key(new_packs, name)
      call def.after_load()
    endif
  endfor
endfunction

" Load the specified opt plugin with hooks.
function! my#pack#load_opt(name)
  let def = b:packs[a:name]
  if has_key(def, 'before_load')
    call def.before_load()
  endif

  execute "packadd" a:name

  if has_key(def, 'after_load')
    call def.after_load()
  endif
endfunction
