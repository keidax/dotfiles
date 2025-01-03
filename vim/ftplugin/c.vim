" Suggest 80-char limit
setlocal colorcolumn=100
" Use tree-sitter for folding
setlocal foldexpr=v:lua.vim.treesitter.foldexpr()
setlocal foldmethod=expr
" Use single-line comments
setlocal commentstring=//\ %s

setlocal expandtab tabstop=4 shiftwidth=4

let b:ale_linters = ['ccls']
