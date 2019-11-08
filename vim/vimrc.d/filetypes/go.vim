Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

" Automatically handle imports along with formatting
let g:go_fmt_command = 'goimports'

" Just use fast linters in the editor
let g:ale_go_golangci_lint_options = '--fast'
" Check the whole package to avoid missing references
let g:ale_go_golangci_lint_package = 1
