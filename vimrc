call plug#begin()
" Make sure to use single quotes
Plug 'tpope/vim-sensible'
Plug 'chriskempson/base16-vim'
Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-pandoc/vim-pandoc-syntax'
Plug 'ConradIrwin/vim-bracketed-paste'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-endwise'
Plug 'thoughtbot/vim-rspec', { 'for': 'ruby' }
Plug 'gisphm/vim-gitignore'
Plug 'skywind3000/asyncrun.vim', { 'on': 'AsyncRun' }
Plug 'powerman/vim-plugin-AnsiEsc', { 'on': 'AnsiEsc' }
call plug#end()

"""""""""""""
"  General  "
"""""""""""""

augroup vimrc
    " Clear previously-set local autocommands
    au!
    " Reload vimrc on write
    autocmd BufWritePost $MYVIMRC,*/{.,}dotfiles/vimrc :source $MYVIMRC
augroup END

" Turn on mouse support
set mouse=a

" Set indentation settings
set expandtab       " Spaces are used instead of tab characters
set tabstop=8       " This should be 8 for compatibility purposes
set shiftwidth=4    " Shifts (>>, etc.) move by 4 spaces
set softtabstop=-1  " <Tab> inserts {shiftwidth} spaces

" Case-insensitive search
set ignorecase

" Highlight search results (can be cleared with Ctrl+L)
set hlsearch


""""""""""""
"  Visual  "
""""""""""""

" Use matching colorscheme from terminal theme, only on startup
augroup vimrc
    autocmd VimEnter *
                \ if filereadable(expand("~/.vimrc_background")) |
                \     let base16colorspace=256 |
                \     source ~/.vimrc_background |
                \ endif
augroup END

" Make background transparent
highlight Normal ctermbg=none

" Configure vim-indent-guides
let g:indent_guides_guide_size = 1
let g:indent_guides_enable_on_vim_startup = 1
" Better colors for base16 dark colorscheme
" (The autocmds preserve our colors even if the colorscheme changes)
let g:indent_guides_auto_colors = 0
augroup vimrc
    autocmd VimEnter,Colorscheme * :highlight IndentGuidesOdd  ctermbg=18
    autocmd VimEnter,Colorscheme * :highlight IndentGuidesEven ctermbg=19
augroup END


""""""""""""""
"  Filetype  "
""""""""""""""
augroup vimrc
    " Use real tabs in makefiles, and turn off all spaces
    autocmd FileType make setlocal noexpandtab shiftwidth=0 tabstop=8 softtabstop=0

    " Use standard indentation and line size for Ruby files
    autocmd FileType ruby setlocal shiftwidth=2 softtabstop=2 colorcolumn=81

    " Use recommended 2-space indent for YAML files
    autocmd FileType yaml setlocal expandtab shiftwidth=2 softtabstop=2
augroup END


""""""""""""""
"  Mappings  "
""""""""""""""
" For learning new habits
inoremap <ESC> <nop>

" Leader
let mapleader = " "

" Quickly edit and source vimrc
nnoremap <Leader>ev :tabedit $MYVIMRC<CR>
nnoremap <Leader>sv :source $MYVIMRC<CR>

" nicer ESC
inoremap jk <ESC>

" Navigate splits
noremap <Leader>j <C-w>j
noremap <Leader>k <C-w>k
noremap <Leader>h <C-w>h
noremap <Leader>l <C-w>l

" vim-rspec mappings
map <Leader>t :call RunCurrentSpecFile()<CR>
map <Leader>s :call RunNearestSpec()<CR>
map <Leader>r :call RunLastSpec()<CR>

" When running vim-rspec
augroup vimrc
    autocmd User AsyncRunStart tab copen
    autocmd User AsyncRunStart :AnsiEsc
augroup END

"""""""""""""""""""""
"  Plugin Settings  "
"""""""""""""""""""""

" vim-rspec settings

" Run rspec with color forced on, through spring, asynchronously, sending
" output to the quickfix window
let g:rspec_command = ":AsyncRun spring rspec --color --tty {spec}"
