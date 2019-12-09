Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

" Automatically handle imports along with formatting
let g:go_fmt_command = 'goimports'

" Let ALE do this
let g:go_fmt_autosave = 0

" Don't use gopls - let Coc do this
let g:go_gopls_enabled = 0

" Don't map `K`
let g:go_doc_keywordprg_enabled = 0

" Just use fast linters in the editor
let g:ale_go_golangci_lint_options = '--fast'
" Check the whole package to avoid missing references
let g:ale_go_golangci_lint_package = 1

let g:ale_go_govet_options = '-composites=false'

" Try this out to add trailing commas for structs
" NOTE: this option could be documented!
if executable('gofmtrlx')
    let g:ale_go_gofmt_executable = 'gofmtrlx'
endif

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
