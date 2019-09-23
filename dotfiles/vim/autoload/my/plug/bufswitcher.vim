function! my#plug#bufswitcher#configure(conf) abort
  let a:conf.repo = 'ryym/bufswitcher.vim'
  let a:conf.depends = ['submode']
  let a:conf.before_load = function('my#plug#bufswitcher#before_load')
endfunction

function my#plug#bufswitcher#before_load()
  let g:bufswitcher_configs = { 'per_tab': 1 }

  SbmDefine bufswitch
  SbmBufswitchEnter n r <Space>bb <Plug>(bufswitcher-show)
  SbmBufswitch n <r> l <Plug>(bufswitcher-next)
  SbmBufswitch n <r> h <Plug>(bufswitcher-prev)
  for i in [1, 2, 3, 4, 5, 6]
    call submode#map('bufswitch', 'n', '', i, ':BufswitcherSwitchTo ' . i . '<CR>')
  endfor

  Map n \[buffer]3 ::BufswitcherSwitchTo 3
endfunction
