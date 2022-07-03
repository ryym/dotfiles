function! my#plug#zig#configure(conf) abort
  let a:conf.repo = 'ziglang/zig.vim'
  let a:conf.async.detect_startup_file = ['zig']
endfunction
