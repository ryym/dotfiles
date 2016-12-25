" Use TypeScript syntax highlight for JavaScript because:
"   - TypeScript includes all of JavaScrpt syntax
"   - Flowtype has almost the same syntax with TypeScript
" So this makes highlight correctly both of normal JS and Flowtyped JS.
autocmd BufNewFile,BufRead *.js,*.ts,*.tsx setlocal filetype=typescript
