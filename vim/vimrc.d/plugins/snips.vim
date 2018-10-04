" Snippet engine with deoplete support
Plug 'SirVer/ultisnips'
" More snippets
Plug 'honza/vim-snippets'

" Snippet completion tweaks
augroup vimrc
    autocmd VimEnter *
        \ call deoplete#custom#source('ultisnips', 'rank', 110) |
        \ call deoplete#custom#source('ultisnips', 'min_pattern_length', 2)
augroup end
