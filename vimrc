call plug#begin()
" Make sure to use single quotes
Plug 'tpope/vim-sensible'
Plug 'chriskempson/base16-vim'
Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-pandoc/vim-pandoc-syntax'
Plug 'zowens/vim-eclim'
call plug#end()

" Access colors present in 256 colorspace
let base16colorspace=256
set background=dark
colorscheme base16-default
" Make background transparent
highlight Normal ctermbg=none

" Detect file type (should be set in sensible.vim)
"filetype plugin indent on

" Turn on mouse support
set mouse=a

" Set indentation settings
set tabstop=8
set softtabstop=0
set shiftwidth=4
set smarttab
set expandtab

" Use real tabs in makefiles, and turn off all spaces
autocmd FileType make setlocal noexpandtab shiftwidth=0 softtabstop=0
