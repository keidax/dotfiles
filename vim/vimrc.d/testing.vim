" Provide mappings for running tests
Plug 'janko-m/vim-test'

" Use custom strategy to run in a Neovim terminal
" see autoload/test/strategy.vim
let test#strategy = 'neovim_custom'

let test#custom_runners = {'Ts_corpus': ['Treesitter_Test']}
