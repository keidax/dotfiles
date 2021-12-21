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
let g:ale_go_golangci_lint_options = '--fast --fix'
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

function! g:CustomGoFixer(buffer_id, lines)
    let l:CallbackPartial = function("CustomGoFixerCallback", [a:lines])

    return {
        \ 'command': 'gofmt -e -d 2>&1',
        \ 'read_buffer': 1,
        \ 'process_with': l:CallbackPartial,
        \ }
endfunction

function! g:CustomGoFixerCallback(input, buffer, output)
    let l:changes = []
    let l:pattern = '^<standard input>:\(\d\+\):\(\d\+\): missing '','' before newline in composite literal$'

    for l:line in a:output
        let l:match = matchlist(l:line, l:pattern)

        if !empty(l:match)
            let l:line_number = str2nr(l:match[1])
            let l:col_number = str2nr(l:match[2])
            let l:changes += [[l:line_number, l:col_number]]
        endif
    endfor

    if empty(l:changes)
        return []
    endif

    for l:change in l:changes
        let l:line_number = l:change[0]
        let l:col_number = l:change[1]

        let l:line = a:input[l:line_number - 1]

        let l:new_line =  l:line[0:l:col_number - 1] . "," . l:line[l:col_number:]

        let a:input[l:line_number - 1] = l:new_line
    endfor

    return a:input
endfunction
