function! my#plug#copilot#configure(conf) abort
  let a:conf.repo = 'github/copilot.vim'
  let a:conf.after_load = function('my#plug#copilot#after_load')

  let g:copilot_no_tab_map = v:true
  let g:copilot_node_command = getenv('VIM_COPILOT_NODE_PATH')

  MapPrefix n <Space>a \[ai]
  Map2 n \[ai]d :<C-u>Copilot disable<CR>
  Map2 n \[ai]e :<C-u>Copilot enable<CR>
  Map2 n \[ai]s :<C-u>Copilot status<CR>

  Remap2 i <M-j> <Plug>(copilot-suggest)
  Remap2 i <M-n> <Plug>(copilot-next)
  Remap2 i <silent> <script> <expr> <M-Enter> copilot#Accept("\<CR>")
endfunction

function! my#plug#copilot#after_load() abort
  " Disable Copilot by default.
  " But you can get a suggestion by `<Plug>(copilot-suggest)` or enable Copilot to auto completion.
  Copilot disable
endfunction
