setlocal shiftwidth=2 softtabstop=2

" Use tree-sitter for folding
setlocal foldexpr=v:lua.vim.treesitter.foldexpr()
setlocal foldmethod=expr

" Run crystal formatter on save
let b:ale_fix_on_save = 1
let b:ale_fixers = [{ -> {
    \ 'command': 'crystal tool format %t',
    \ 'read_temporary_file': 1
    \ } }]
