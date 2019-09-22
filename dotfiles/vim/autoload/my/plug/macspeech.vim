function! my#plug#macspeech#configure(conf) abort
  let a:conf.repo = 'ryym/macspeech.vim'
  let a:conf.install_if = g:is_mac
  let a:conf.before_load = function('my#plug#macspeech#before_load')
endfunction

function! my#plug#macspeech#before_load()
  let g:macspeech_voice = 'Ava'
  Map v  <Leader><Leader>q :r:MacSpeechSelected
  Map nv <Leader><Leader>Q ::MacSpeechStop
endfunction
