function! my#plug#elixir#configure(conf) abort
  let a:conf.repo = 'elixir-lang/vim-elixir'
  let a:conf.async.detect_startup_file = ['ex', 'exs', 'eex', 'leex']
endfunction
