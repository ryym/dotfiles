function! my#plug#copilot#configure(conf) abort
  let a:conf.repo = 'github/copilot.vim'
  let a:conf.after_load = function('my#plug#copilot#after_load')

  let g:copilot_no_tab_map = v:true
  let g:copilot_node_command = getenv('VIM_COPILOT_NODE_PATH')

  MapPrefix n <Space>a \[ai]
  Map n \[ai]d :<C-u>Copilot disable<CR>
  Map n \[ai]e :<C-u>Copilot enable<CR>
  Map n \[ai]s :<C-u>Copilot status<CR>

  Remap i <M-j> <Plug>(copilot-suggest)
  Remap i <M-n> <Plug>(copilot-next)
  Remap i <silent> <script> <expr> <M-Enter> copilot#Accept("\<CR>")
endfunction

function! my#plug#copilot#after_load() abort
  " Disable Copilot by default.
  " But you can get a suggestion by `<Plug>(copilot-suggest)` or enable Copilot to auto completion.
  Copilot disable
endfunction
