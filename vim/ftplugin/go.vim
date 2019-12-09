" Tab settings
setlocal noexpandtab
setlocal tabstop=4 shiftwidth=4

" Enable folding
setlocal foldmethod=syntax

let b:ale_linters = ['gofmt', 'golint', 'go vet', 'golangci-lint']
let b:ale_fixers = ['gofmt', 'goimports']
let b:ale_fix_on_save = 1

highlight link goFunctionCall Function
