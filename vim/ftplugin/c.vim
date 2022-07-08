" Suggest 80-char limit
setlocal colorcolumn=100
" Use syntax folding
setlocal foldmethod=syntax
" Use single-line comments
setlocal commentstring=//\ %s

setlocal expandtab tabstop=4 shiftwidth=4

let b:ale_linters = ['ccls']
