"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Syntax file for vim files
"""""""""""""""""""""""""""""""""""""""""""""""""""""""

" For $MYVIMDIR/autoload/w/mapping.vim {{{

highlight link MyVimMap         vimMap
highlight link MyVimMapNamedKey vimMap
highlight link MyVimMapToggle   vimMap
highlight link MyVimMapTextObj  vimMap
highlight link MyVimMapModeChar vimSpecial
highlight link MyVimMapType     vimMapMod

syntax match MyVimMap         '\v^\s*<%(Rem|M)ap>'  skipwhite nextgroup=MyVimMapModeChar
syntax match MyVimMapNamedKey '\v^\s*<MapNamedKey>' skipwhite nextgroup=vimMapLhs
syntax match MyVimMapToggle   '\v^\s*<MapToggle>'   skipwhite nextgroup=vimMapLhs
syntax match MyVimMapTextObj  '\v^\s*<MapTextObj>'  skipwhite nextgroup=vimMapLhs
syntax match MyVimMapModeChar '\v[nvxsoic]+' contained skipwhite nextgroup=MyVimMapType,vimMapLhs
syntax match MyVimMapType     '\v\([^)]+\)'  contained skipwhite nextgroup=vimMapLhs

syntax cluster vimFuncBodyList add=MyVimMap,MyVimMapNamedKey,MyVimMapToggle,MyVimMapTextObj

"  }}}
