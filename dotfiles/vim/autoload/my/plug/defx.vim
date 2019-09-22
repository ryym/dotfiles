function! my#plug#defx#configure(conf) abort
  let a:conf.repo = 'Shougo/defx.nvim'
  let a:conf.after_load = function('my#plug#defx#after_load')
endfunction

function! my#plug#defx#after_load()
  MapNamedKey <Space>f defx
  Map n \[defx]E ::Defx -split=vertical -winwidth=35
  Map n \[defx]e ::call my#plug#defx#_open_buffer_dir()
  Map n \[defx]c ::call my#plug#defx#_close_filer()

  autocmd vimrc FileType defx call <SID>configure_defx_buffer()
endfunction

function! s:configure_defx_buffer() abort
  " https://github.com/Shougo/defx.nvim/issues/13#issuecomment-424909116
  Map n (silent buffer expr) l defx#do_action('open', 'wincmd w \| drop')

  Map n (silent buffer expr) h defx#do_action('cd', '..')
  Map n (silent buffer expr) f defx#do_action('open_or_close_tree')
  Map n (silent buffer expr) F defx#do_action('open_tree_recursive')
  Map n (silent buffer expr) C defx#do_action('new_file')
  Map n (silent buffer expr) K defx#do_action('new_directory')
  Map n (silent buffer expr) yy defx#do_action('yank_path')
  Map n (silent buffer expr) dd defx#do_action('remove')
  Map n (silent buffer expr) cc defx#do_action('copy')
  Map n (silent buffer expr) mm defx#do_action('move')
  Map n (silent buffer expr) p defx#do_action('paste')
  Map n (silent buffer expr) r defx#do_action('rename')
  Map n (silent buffer expr) <C-l> defx#do_action('redraw')
  Map n (silent buffer expr) <C-g> defx#do_action('print')
  Map n (silent buffer expr) . defx#do_action('toggle_ignored_files')
endfunction

function! my#plug#defx#_open_buffer_dir() abort
  execute 'Defx -split=vertical -winwidth=35 ' . expand('%:h')
endfunction

function! my#plug#defx#_close_filer() abort
  let bufnr = s:find_defx_bufnr()
  if bufnr != -1
    execute 'bdelete ' . bufnr
  endif
endfunction

function s:find_defx_bufnr() abort
  for bufnr in tabpagebuflist()
    let ft = getbufvar(bufnr, '&filetype')
    if ft == 'defx'
      return bufnr
    endif
  endfor
  return -1
endfunction
