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
" Let vim-closetag work with XSD, XSLT files
let g:closetag_filenames = "*.xml,*.html,*.xsd,*.xsl"
Plug 'alvan/vim-closetag'
Plug 'airblade/vim-gitgutter'
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

" Cut-and-paste operations use the system clipboard
set clipboard=unnamed,unnamedplus

" Faster update time (pick up changes in vim-gitgutter)
set updatetime=250

""""""""""""
"  Visual  "
""""""""""""

augroup vimrc
    " Use matching colorscheme from terminal theme, only on startup
    autocmd VimEnter *
                \ if filereadable(expand("~/.vimrc_background")) |
                \     let base16colorspace=256 |
                \     source ~/.vimrc_background |
                \ endif

    " Make background transparent
    autocmd VimEnter,ColorScheme * :highlight Normal ctermbg=none

    " Transparent split backgrounds
    autocmd VimEnter,ColorScheme * :highlight VertSplit ctermbg=none
    autocmd VimEnter,ColorScheme * :highlight StatusLineNC ctermbg=none
augroup END

" Window border styles
set fillchars=vert:│,stl:━,stlnc:─

" Better indent colors for base16 dark colorscheme
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
    autocmd FileType ruby setlocal shiftwidth=2 softtabstop=2 colorcolumn=101

    " Use recommended 2-space indent for YAML files
    autocmd FileType yaml setlocal expandtab shiftwidth=2 softtabstop=2

    " Use 2-space indent for XML and family
    autocmd FileType xml,xsd,xslt setlocal expandtab shiftwidth=2 softtabstop=2
    " Formatting with xmllint
    autocmd FileType xml,xsd,xslt setlocal equalprg=xmllint\ --format\ --recover\ -
augroup END


""""""""""""""
"  Mappings  "
""""""""""""""
" For learning new habits, Konami-style
" (Thanks to tylercipriani.com/vim.html)
noremap <Up> <nop>
noremap! <Up> <nop>
noremap <Down> <nop>
noremap! <Down> <nop>
noremap <Left> <nop>
noremap <Right> <nop>
noremap! <Left> <nop>
noremap! <Right> <nop>
" B-A-<start>

cnoremap <ESC> <nop>
vnoremap <ESC> <nop>

" Leader
let mapleader = " "

" Quickly edit and source vimrc
nnoremap <Leader>ev :tabedit $MYVIMRC<CR>
nnoremap <Leader>sv :source $MYVIMRC<CR>

" Faster ESC
inoremap jk <ESC>
vnoremap jk <ESC>
" Commandline mode (<ESC> from a mapping actually executes the command!)
cnoremap jk <C-c>

" Navigate splits
noremap <Leader>j <C-w>j
noremap <Leader>k <C-w>k
noremap <Leader>h <C-w>h
noremap <Leader>l <C-w>l

" Same-width/height splits
nnoremap <Leader>sh :leftabove  vsplit<CR>
nnoremap <Leader>sj :rightbelow  split<CR>
nnoremap <Leader>sk :leftabove   split<CR>
nnoremap <Leader>sl :rightbelow vsplit<CR>

" Same-width/height windows
nnoremap <Leader>nh :leftabove  vnew<CR>
nnoremap <Leader>nj :rightbelow  new<CR>
nnoremap <Leader>nk :leftabove   new<CR>
nnoremap <Leader>nl :rightbelow vnew<CR>

" Full-width/height splits
nnoremap <Leader>swh :topleft  vsplit<CR>
nnoremap <Leader>swj :botright  split<CR>
nnoremap <Leader>swk :topleft   split<CR>
nnoremap <Leader>swl :botright vsplit<CR>

" Full-width/height new windows
nnoremap <Leader>nwh :topleft  vnew<CR>
nnoremap <Leader>nwj :botright  new<CR>
nnoremap <Leader>nwk :topleft   new<CR>
nnoremap <Leader>nwl :botright vnew<CR>

" vim-rspec mappings
map <Leader>t :call RunCurrentSpecFile()<CR>
map <Leader>s :call RunNearestSpec()<CR>
map <Leader>r :call RunLastSpec()<CR>

" When running vim-rspec
augroup vimrc
    autocmd User AsyncRunStart tab copen
    autocmd User AsyncRunStart :AnsiEsc
augroup END

" Make netrw-v open split on the right instead of left
let g:netrw_altv=1

"""""""""""""""""""""
"  Plugin Settings  "
"""""""""""""""""""""

" vim-rspec settings

" Run rspec with color forced on, through spring, asynchronously, sending
" output to the quickfix window
let g:rspec_command = ":AsyncRun spring rspec --color --tty {spec}"

" Configure vim-indent-guides
let g:indent_guides_guide_size = 1
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_start_level = 2
