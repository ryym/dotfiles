"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Syntax file for vim files
"""""""""""""""""""""""""""""""""""""""""""""""""""""""

" For $MYVIMDIR/autoload/w/mapping.vim {{{

highlight link MyVimMap         vimMap
highlight link MyVimMapName     vimMap
highlight link MyVimMapToggle   vimMap
highlight link MyVimMapModeChar vimSpecial
highlight link MyVimMapType     vimMapMod

syntax match MyVimMap         '\v^\s*<%(Rem|M)ap>' skipwhite nextgroup=MyVimMapModeChar
syntax match MyVimMapName     '\v^\s*<NameMap>'    skipwhite nextgroup=vimMapLhs
syntax match MyVimMapToggle   '\v^\s*<MapToggle>'  skipwhite nextgroup=vimMapLhs
syntax match MyVimMapModeChar '\v[nvxsoic]+' contained skipwhite nextgroup=MyVimMapType,vimMapLhs
syntax match MyVimMapType     '\v\([^)]+\)'  contained skipwhite nextgroup=vimMapLhs

syntax cluster vimFuncBodyList add=MyVimMap,MyVimMapName,MyVimMapToggle

"  }}}
