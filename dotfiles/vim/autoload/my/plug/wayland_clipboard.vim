" In Wayland native terminal emulator, Vim cannot access the clipboard.
" https://github.com/swaywm/sway/issues/5352
function! my#plug#wayland_clipboard#configure(conf) abort
  let a:conf.repo = 'jasonccox/vim-wayland-clipboard'
  " Neovim works out of the box so don't need to load this plugin.
  let a:conf.skip_load = has('nvim')
endfunction
