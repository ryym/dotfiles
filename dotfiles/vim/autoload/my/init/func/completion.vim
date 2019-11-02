let s:file_completion_curdir = ''

" Improve file path completion.
" Vim has a file name completion but it is done from the
" current directory, not a directory of a current file.
" But I want to do it from the current file's directory.
" To achieve this, we need to change the current directory
" temporaliry while completion.
function! my#init#func#completion#files()
  let cwd = getcwd()
  let file_dir = expand("%:p:h")

  if empty(s:file_completion_curdir) && cwd != file_dir
    augroup vimrc_file_completion
      autocmd InsertLeave * call <SID>restore_current_dir()
    augroup END
    let s:file_completion_curdir = cwd
  endif

  call execute('cd ' . file_dir)
  return "\<C-x>\<C-f>"
endfunction

function! s:restore_current_dir()
  call execute('cd ' . s:file_completion_curdir)
  let s:file_completion_curdir = ''
  augroup vimrc_file_completion
    autocmd!
  augroup END
endfunction
