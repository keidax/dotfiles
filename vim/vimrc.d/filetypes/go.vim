Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

" Automatically handle imports along with formatting
let g:go_fmt_command = 'goimports'

" Just use fast linters in the editor
let g:ale_go_golangci_lint_options = '--fast'
" Check the whole package to avoid missing references
let g:ale_go_golangci_lint_package = 1

" More colors
let g:go_highlight_space_tab_error = 1
let g:go_highlight_array_whitespace_error = 1
let g:go_highlight_chan_whitespace_error = 1
let g:go_highlight_trailing_whitespace_error = 1

let g:go_highlight_extra_types = 1
let g:go_highlight_types = 1

let g:go_highlight_operators = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1

let g:go_highlight_string_spellcheck = 1
let g:go_highlight_build_constraints = 1
