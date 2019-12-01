" Asynchronous linter
Plug 'w0rp/ale'

" Nicer symbols (require nerd font)
let g:ale_sign_error = '✕'
let g:ale_sign_warning = '⚠'

" Don't touch the lists
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 0

" Show virtualtext
let g:ale_virtualtext_cursor = 1

" Linter settings
" Display cop names & extra details, and run extra Rails cops
let g:ale_ruby_rubocop_options = '-D -E'

" Ignore errors occuring when shellcheck can't follow a sourced file
let g:ale_linters_sh_shellcheck_exclusions = 'SC1090,SC1091'

" Fixer settings
let g:ale_fix_on_save = 0

let g:ale_fixers = {
    \ '*': ['trim_whitespace', 'remove_trailing_lines'],
    \ 'json': ['prettier'],
    \ }

" We're using coc.nvim for this
let g:ale_disable_lsp = 1

let g:ale_c_parse_compile_commands = 1
