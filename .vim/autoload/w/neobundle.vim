"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" The wrapper of neobundle.vim
"
" The mini NeoBundle wrapper
" that makes settings of bundles more simple
" and normalize bundle names automatically.
"""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Wrapper functions {{{

" The wrapper commands of 'NeoBundle' to normalize bundle names automatically.
function! w#neobundle#wrap()
  command! -nargs=1 NeoBundlew     call <SID>normalize_and_add_bundle([<args>])
  command! -nargs=1 NeoBundlewLazy call <SID>normalize_and_add_bundle_lazy([<args>])
endfunction

" Execute loadings and settings of bundles by NeoBundle
" based on the configuration defined in the `a:configs`.
function! w#neobundle#execute(configs)
  let configs = a:configs

  if ! ( has_key(configs, 'declare_bundles') && has_key(configs, 'configure_bundles') )
    echoerr '[neobundle_w] declare_bundles() and configure_bundles() fundcions are required.'
    return
  endif

  if has('vim_starting')
    if &compatible
      set nocompatible
    endif
    execute 'set runtimepath+=' . configs.bundle_dir . '/neobundle.vim'
  endif

  call neobundle#begin(configs.bundle_dir)

  if neobundle#load_cache(configs.vimrc)
    NeoBundleFetch 'Shougo/neobundle.vim'
    call configs.declare_bundles()
    NeoBundleCheck
    NeoBundleSaveCache
  endif
 
  call configs.configure_bundles( s:generate_wrapper() )

  call neobundle#end()
  filetype plugin indent on
endfunction
" }}}

" Helper functions {{{

" Normalize bundle names by the rule:
"   replace all '_' to '-'
"   remove prefixes like 'vim-'
"   remove suffixes like '.vim', '-vim'
function! s:normalize_bundle_name(name)
  let name = substitute(a:name, '_', '-', 'g')
  if name =~ '^vim-'
    let name = name[4:]
  endif
  if name =~ '[-.]vim$'
    let name = name[:-5]
  endif
  return name
endfunction

" Let a bundle managed by NeoBundle after normalizing it's bundle name.
function! s:normalize_and_add_bundle(args)
  let bundle_path    = a:args[0]
  let bundle_options = ( len(a:args) == 2 ) ? a:args[1] : {}

  if ! has_key(bundle_options, 'name')
    let tail_of_path        = fnamemodify(bundle_path, ':t')
    let bundle_options.name = s:normalize_bundle_name(tail_of_path)
  endif

  call neobundle#bundle(bundle_path, bundle_options)
endfunction

" Let a bundle managed by NeoBundle for lazy-load after normalizing it's bundle name.
function! s:normalize_and_add_bundle_lazy(args)
  let bundle_options      = ( len(a:args) == 2 ) ? a:args[1] : {}
  let bundle_options.lazy = 1
  call s:normalize_and_add_bundle([a:args[0], bundle_options])
endfunction

" Generate a object that wraps some functionalities of NeoBundle.
function! s:generate_wrapper() "{{{
  let wrapper = {}

  " Try to tap bundle. If the given bundle name is invalid, do nothing.
  function! wrapper.try_tap(bundle_name) dict
    if neobundle#tap(a:bundle_name)
      let self.tapped = g:neobundle#tapped
      let self.hooks  = g:neobundle#hooks
      return 1
    else
      return 0
    endif
  endfunction

  " Tap bundle. If the given bundle name is invalid, echo error message.
  function! wrapper.tap(bundle_name) dict
    if self.try_tap(a:bundle_name)
      return 1
    else
      echoerr '[neobundle_w]' a:bundle_name." doesn't exist or is disabled."
      return 0
    endif
  endfunction

  return wrapper
endfunction " }}}

" }}}

