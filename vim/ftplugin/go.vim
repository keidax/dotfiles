" Tab settings
setlocal noexpandtab
setlocal tabstop=4 shiftwidth=4

" Enable folding
setlocal foldmethod=syntax

let b:ale_linters = ['gofmt', 'golint', 'go vet', 'golangci-lint']

highlight link goFunctionCall Function
