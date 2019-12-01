" Suggest 80-char limit
setlocal colorcolumn=80
" Use syntax folding
setlocal foldmethod=syntax
" Use single-line comments
setlocal commentstring=//\ %s

setlocal noexpandtab tabstop=8

let b:ale_linters = ['ccls']
