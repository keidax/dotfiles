" NOTE: Apparently this can also cause the welcome message to disappear
Plug 'neoclide/coc.nvim', {'do': { -> coc#util#install()}}

" For vim completion
Plug 'Shougo/neco-vim'
Plug 'neoclide/coc-neco'  " Not in NPM registry

let g:coc_global_extensions = [
    \ 'coc-json',
    \ 'coc-snippets',
    \ 'coc-solargraph',
    \ ]
