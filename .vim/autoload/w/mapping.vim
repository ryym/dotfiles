"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" The wrapper of default mapping commands
"
" Usage {{{
"
" Map   {modes} [{options}] {lhs} {rhs}
" Remap {modes} [{options}] {lhs} {rhs}
"
"   The wrapper commands of default mapping commands like
"   'nmap', 'vnoremap', and so on.
"   Note: 'Map' is a wrapper of 'noremap'. And 'Remap' is a
"   wrapper of 'map'.
"
"   {modes} is sequence of characters. Each character
"   indicates vim mode {lhs} works in. Valid characters
"   of {modes} are first chahacters of default mapping
"   commands ('n'map, 'v'map, ..).
"   {options} is special arguments of mapping command like
"   '<buffer>', '<silent>', and so on. But in these custom
"   commands, the arguments must be surrounded by parentheses.
"   If the argument is multiple all arguments must be in one
"   parentheses and separated by space.
"   {lhs} is same as default commands.
"   {rhs} is almost same as default commands. But in the
"   case of ex command, special syntax can be used.
"
"   Syntax     Converted rhs
"   ::echo      :<C-u>echo<CR>
"   :u:echo     :<C-u>echo
"   :r:echo     :echo<CR>
"   :s:echo     :echo<Space>
"   :f:func(0)  :call func(0)<CR>
"
"   Example:
"     Map nv (buffer uniq) x "_x
"   
" MapNamedKey {name} {key}
"
"   Define a named key by mapping \[{name}] key sequence to {key}.
"   Named key is typically used as a prefix of other mappings.
"   Using named key as a prefix makes vimrc more maintainable.
"   Note: All named keys defined this command start with '\'
"   to avoid conflicting with other mappings starting with '['.
"
"   Example:
"     MapNamedKey buffer <Space>b
"     Map n \[buffer]a ::buffer #
"     Map n \[buffer]d ::bdelete
"
" MapToggle {key} {option}
"   
"   Define mapping for toggling {option} (:set(l) {option}!).
"   This command prefixes '\[toggle]' to all {key}s.
"
" }}}
"""""""""""""""""""""""""""""""""""""""""""""""""""""""

let s:current_sid = ''

" Common {{{

function! w#mapping#load(sid)
  command! -nargs=+ Map         call w#mapping#define(0, <f-args>)
  command! -nargs=+ Remap       call w#mapping#define(1, <f-args>)
  command! -nargs=+ MapNamedKey call w#mapping#map_named_key(<f-args>)
  command! -nargs=+ MapToggle   call w#mapping#map_option_toggling(<f-args>)

  call w#mapping#set_sid(a:sid)
endfunction

function! w#mapping#set_sid(sid)
  if ! empty(a:sid)
    let s:current_sid = '<SNR>' . a:sid . '_'
  endif
endfunction

" }}}

" Map, Remap {{{

function! w#mapping#define(remap, ...)
  let [modes, opts, lhs, rhs] = s:parse_args(a:000)
  let map_cmd = a:remap ? 'map' : 'noremap'
  for mode in split(modes, '\zs')
    execute mode . map_cmd opts lhs rhs
  endfor
endfunction

function! s:parse_args(args) " {{{
  let map_opts = s:find_options(a:args)
  let lhs_idx  = 1 + len(map_opts)

  let modes = a:args[0]
  let opts  = s:convert_options(map_opts)
  let lhs   = a:args[lhs_idx]
  let rhs   = join( a:args[(lhs_idx + 1): ] )

  if rhs =~ '<SID>'
    let rhs = s:resolve_sid(rhs)
  endif

  if rhs =~ '^:'
    let rhs = s:parse_ex_command_rhs(rhs)
  endif

  return [modes, opts, lhs, rhs]
endfunction "}}}

function! s:find_options(args) "{{{
  if a:args[1] !~ '^('
    return []
  endif

  let closed_parens = filter( copy(a:args), "v:val =~ ')$'" )
  if len(closed_parens) == 0
    return []
  endif

  let opt_end_idx = index(a:args, closed_parens[0])
  return a:args[1 : opt_end_idx]
endfunction "}}}

function! s:convert_options(opts) "{{{
  if len(a:opts) == 0
    return ''
  endif

  " Remove parens
  let a:opts[0]  = a:opts[0][1:]
  let a:opts[-1] = a:opts[-1][:-2]

  call filter(a:opts, '0 < len(v:val)')
  return join( map(a:opts, "'<' . v:val . '>'"), '' )
endfunction "}}}

function! s:resolve_sid(rhs) "{{{
  if empty(s:current_sid)
    echoerr "[mapping] <SID> doesn't defined. Please set <SID> by w#mapping#set_sid()."
  endif
  return substitute(a:rhs, '<SID>', s:current_sid, 'g')
endfunction "}}}

function! s:parse_ex_command_rhs(rhs) "{{{
  let matches = matchlist(a:rhs, '\v%(^:(\w*):)@<=.+$')
  if empty(matches)
    return a:rhs
  endif

  let rhs   = matches[0]
  let flags = matches[1]
  if empty(flags) " ::
    let flags = 'ur'
  endif

  for flag in s:rhs_filters.order
    if flags =~# flag
      let func_name = s:rhs_filters.func_map[flag]
      let rhs       = s:rhs_filters.filters[func_name](rhs)
    endif
  endfor

  return ':' . rhs
endfunction "}}}

" rhs_filters {{{

let s:rhs_filters = {
  \ 'order': ['f', 'u', 'r', 's'],
  \ 'filters': {},
  \ 'func_map': {
  \   'f': 'call_function',
  \   'u': 'reset_command_line',
  \   'r': 'end_with_return',
  \   's': 'end_with_space'
  \   }
  \ }

function! s:rhs_filters.filters.call_function(rhs)
  return 'call ' . a:rhs . '<CR>'
endfunction

function! s:rhs_filters.filters.reset_command_line(rhs)
  return '<C-u>' . a:rhs
endfunction

function! s:rhs_filters.filters.end_with_return(rhs)
  return a:rhs . '<CR>'
endfunction

function! s:rhs_filters.filters.end_with_space(rhs)
  return a:rhs . '<Space>'
endfunction

" }}}

" }}}

" MapNamedKey {{{

function! w#mapping#map_named_key(name, key)
  let command_name = '\[' . a:name . ']'
  execute 'nnoremap' command_name '<Nop>'
  execute 'nmap'     a:key        command_name
endfunction

" }}}

" MapToggle {{{

function! w#mapping#map_option_toggling(key, option)
  " Toggle the option and display the changed value.
  let cmd = a:option . '! ' . a:option . '?'
  let lkey = a:key
  let ukey = toupper(a:key)
  execute 'nnoremap \[toggle]' . lkey . ' :setlocal ' . cmd . '<CR>'
  execute 'nnoremap \[toggle]' . ukey . ' :set '      . cmd . '<CR>'
endfunction

" }}}

