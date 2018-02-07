" Provide mappings for running tests
Plug 'janko-m/vim-test'
" Use dispatch as the test runner
let test#strategy = "dispatch"

" Asynchronous job runner
Plug 'tpope/vim-dispatch'

if has("nvim")
    " Use neovim's terminal for running dispatch jobs
    Plug 'radenling/vim-dispatch-neovim'
endif
