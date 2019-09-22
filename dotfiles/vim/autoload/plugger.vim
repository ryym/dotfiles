" My plugin manager
"
" - One configuration file for one plugin
"     - It makes plugin management easy and scalable rather than
"       putting all plugin configurations together in a single file.
" - Allow to define before/after load hook
"     - It is important that we can define them in a one place per plugin.
" - Use Vim's package system
"     - Put all plugins in the '/opt' directory for easy enabling/disabling.

let s:conf = {
  \   'pack_root': '',
  \   'conf_root': '',
  \   'autoload_prefix': 'my#plug#',
  \   'is_debug': 0,
  \ }

let s:repo_root = expand('<sfile>:p:h:h')

function! plugger#enable(conf) abort
  call plugger#setup(a:conf)
  call plugger#load_plugins()
endfunction

function! plugger#setup(conf) abort
  " Default paths.
  let first_packpath = split(&packpath, ',')[0]
  let s:conf.pack_root = first_packpath . '/pack/plugs/opt/'
  let s:conf.conf_root = first_packpath . '/autoload/my/plug/'

  for key in keys(s:conf)
    if has_key(a:conf, key)
      let s:conf[key] = a:conf[key]
    endif
  endfor

  command! -nargs=+ PluggerAdd call plugger#add_conf_templates(<f-args>)
  command! PluggerInstall call plugger#install_new()
endfunction

" Load all plugin configurations and load plugins.
" This ignores not installed plugins.
function! plugger#load_plugins() abort
  let plugs = s:load_configs()

  for key in plugs.keys
    let conf = plugs.confs[key]
    if conf.skip_load || !conf.installed
      continue
    endif

    call s:load_plugin(key, plugs)
  endfor
endfunction

function! s:initial_conf() abort
  return { 'repo': '', 'depends': [], 'install_if': 1, 'skip_load': 0, 'installed': 0 }
endfunction

" Install configured but not installed plugins.
function! plugger#install_new() abort
  let plugs = s:load_configs()
  let repos = []
  for key in plugs.keys
    let conf = plugs.confs[key]
    if !conf.installed && conf.install_if
      call add(repos, {'name': key, 'url': conf.repo})
    endif
  endfor

  if len(repos) == 0
    echom 'All plugins are installed already'
    return
  endif

  let ctx = {'plugs': plugs, 'repos': repos, 'errs': {}}

  function ctx.on_stdout(_ch, out) abort
    echom a:out
  endfunction

  function ctx.on_stderr(_ch, errs) abort
    let self.errs = json_decode(a:errs)
  endfunction

  function ctx.on_close(_ch) abort
    if len(self.errs) == 0
      echom len(self.repos) 'plugins have been installed'
    else
      echohl ErrorMsg
      for key in keys(self.errs)
        echom '[plugger]: FAIL ' . key . ' ' . self.errs[key].message
      endfor
      echom len(self.errs) 'installations have failed (see messages)'
      echohl None
    endif

    for repo in self.repos
      if !has_key(self.errs, repo.name)
        let conf = self.plugs.confs[repo.name]
        let conf.installed = 1
        if !conf.skip_load
          call s:load_plugin(repo.name, self.plugs)
        endif
      endif
    endfor
  endfunction

  if !isdirectory(s:conf.pack_root)
    call mkdir(s:conf.pack_root, 'p')
  endif

  echom 'Installing ' . len(repos) . ' plugins...'
  let arg = {
    \   'root_dir': s:conf.pack_root,
    \   'is_debug': s:conf.is_debug,
    \   'plugins': repos,
    \ }

  " TODO: Execute in a terminal window.
  call job_start(
    \   [s:repo_root . '/scripts/install-plugins', json_encode(arg)],
    \   {
    \     'out_cb': ctx.on_stdout,
    \     'err_cb': ctx.on_stderr,
    \     'close_cb': ctx.on_close,
    \   },
    \ )
endfunction

function! plugger#plugin_path(key)
  return s:conf.pack_root . a:key
endfunction

function! s:load_configs() abort
  let conf_paths = globpath(s:conf.conf_root, '*', 0, 1)
  let plugs = {'keys': [], 'confs': {}}

  for path in conf_paths
    let key = s:conf_name(path)

    let conf = s:initial_conf()
    let conf.installed = isdirectory(s:conf.pack_root . key)

    call function(s:conf.autoload_prefix . key . '#configure')(conf)

    if conf.repo != ''
      " Currently all plugins I use are hosted on GitHub.
      let conf.repo = 'https://github.com/' . conf.repo
    endif

    for dep in conf.depends
      if !has_key(plugs.confs, dep)
        call add(plugs.keys, dep)
        let plugs.confs[dep] = s:initial_conf()
      endif
    endfor

    if !has_key(plugs.confs, key)
      " It may be already added by another plugin which depends on it.
      call add(plugs.keys, key)
    endif
    let plugs.confs[key] = conf
  endfor

  return plugs
endfunction

function! s:conf_name(path) abort
  return fnamemodify(a:path, ':t:r')
endfunction

" Note that this does not check skip or installed state.
function! s:load_plugin(key, plugs) abort
  if !has_key(a:plugs.confs, a:key)
    throw '[plugger] unknown plugin' a:key
  endif

  let conf = a:plugs.confs[a:key]
  if conf.repo == ''
    throw '[plugger] repository of ' . a:key . ' not configured'
  endif

  let deps_ok = 1
  for dep in conf.depends
    let d = a:plugs.confs[dep]
    if d.repo == '' || d.skip_load || !d.installed
      let deps_ok = 0
      break
    endif
  endfor
  if !deps_ok
    return
  endif

  if has_key(conf, 'before_load')
    call conf.before_load()
  endif

  execute 'packadd' a:key
  let doc_dir = s:conf.pack_root . '/' . a:key . '/doc'
  if isdirectory(doc_dir)
    execute 'helptags' doc_dir
  endif

  if has_key(conf, 'after_load')
    call conf.after_load()
  endif
endfunction

function! plugger#add_conf_templates(...) abort
  for cmd in a:000
    let cmds = split(cmd, ':')
    call plugger#add_conf_template(cmds[0], join(cmds[1:], ''))
  endfor
endfunction

function! plugger#add_conf_template(name, repo) abort
  if !isdirectory(s:conf.conf_root)
    call mkdir(s:conf.conf_root, 'p')
  endif

  let filepath = s:conf.conf_root . a:name . '.vim'

  if filereadable(filepath)
    echohl ErrorMsg
    echom '[plugger]' a:name filepath 'already exists'
    echohl None
    return
  endif

  let lines = [
    \ 'function! ' . s:conf.autoload_prefix . a:name . '#configure(conf) abort',
    \ "  let a:conf.repo = '" . a:repo . "'",
    \ 'endfunction',
    \ ]
  call writefile(lines, filepath)
endfunction
