" Asynchronous linter
Plug 'w0rp/ale'

" Nicer symbols (require nerd font)
let g:ale_sign_error = ''
let g:ale_sign_warning = ''

" Linter settings
" Display cop names & extra details, and run extra Rails cops
let g:ale_ruby_rubocop_options = '-D -E -R'

" Ignore errors occuring when shellcheck can't follow a sourced file
let g:ale_linters_sh_shellcheck_exclusions = 'SC1090,SC1091'
