call plug#begin()
" Make sure to use single quotes
Plug 'tpope/vim-sensible'
Plug 'chriskempson/base16-vim'
Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-pandoc/vim-pandoc-syntax'
Plug 'ConradIrwin/vim-bracketed-paste'
call plug#end()

" Use matching colorscheme from terminal theme
if filereadable(expand("~/.vimrc_background"))
    " Access colors present in 256 colorspace
    let base16colorspace=256
    source ~/.vimrc_background
endif
" Make background transparent
highlight Normal ctermbg=none

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

" Case-insensitive search
set ignorecase

" Highlight search results (can be cleared with Ctrl+L)
set hlsearch
