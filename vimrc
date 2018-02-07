call plug#begin()
" Make sure to use single quotes
Plug 'tpope/vim-sensible'
Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-pandoc/vim-pandoc-syntax'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-endwise'
Plug 'thoughtbot/vim-rspec', { 'for': 'ruby' }
" Let vim-closetag work with XSD, XSLT files
let g:closetag_filenames = "*.xml,*.html,*.xsd,*.xsl"
Plug 'alvan/vim-closetag'
Plug 'jiangmiao/auto-pairs'
Plug 'dahu/vim-fanfingtastic'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all --no-update-rc' }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-surround'
Plug 'mileszs/ack.vim'
" Better performance on e.g. large Ruby files
Plug 'Konfekt/FastFold'
Plug 'kana/vim-textobj-user'
Plug 'nelstrom/vim-textobj-rubyblock'

" Bring some of neovim's goodies like focus reporting and cursor shaping to
" terminal vim. Also activates bracketed paste and full mouse support, and
" handles `:checktime` on focus.
Plug 'wincent/terminus'

" Set modern alt/meta mappings: most modern terminals will output Alt-x as Esc-x
" instead of setting the meta bit. This plugin updates Vim's expectations.
"
" In iTerm2, this requires the "Esc+" setting for the Option keys (since Macs
" use Option+key for different characters).
if !has('nvim')
    Plug 'drmikehenry/vim-fixkey'
endif
Plug 'szw/vim-maximizer'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'wvffle/vimterm'
Plug 'tpope/vim-unimpaired'


"""""""""""""
"  General  "
"""""""""""""

augroup vimrc
    " Clear previously-set local autocommands
    au!
    " Reload vimrc on write
    autocmd BufWritePost $MYVIMRC,*/{.,}vimrc :source $MYVIMRC | doauto VimEnter
augroup END

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

" Commandline completion fills in longest common substring, then cycles options
set wildmode=longest:full,full

" Go to the previous tab instead of the next when closing a tab
augroup vimrc
    autocmd TabClosed * :tabprevious
augroup END

" New windows open where expected
set splitbelow splitright

" Terminus handles the FocusGained events, but we also want to check when
" leaving a terminal buffer.
augroup vimrc
    autocmd BufEnter * checktime
augroup END

" Allow buffers to stay loaded in the background
set hidden

""""""""""""
"  Visual  "
""""""""""""

" Turn off all folds by default
set nofoldenable
augroup vimrc
    " For filetypes with folding enabled, start unfolded. We have to use an
    " autocmd because 'foldlevelstart' is also applied when switching to a
    " loaded buffer.
    autocmd BufReadPost * normal zR
augroup END

set foldtext=MyFoldText()
" Inspired by https://coderwall.com/p/usd_cw/a-pretty-vim-foldtext-function
function! MyFoldText()
    let l:padding = &foldcolumn + &number * &numberwidth

    " Test if any signs exist
    redir => l:signs
      execute 'silent sign place buffer='.bufnr('%')
    redir End
    let l:padding += l:signs =~# 'id=' ? 2 : 0

    let l:windowwidth = winwidth(0) - l:padding
    let l:windowwidth = min([l:windowwidth, 100])

    let l:starttext = substitute(getline(v:foldstart), '\s*$', '', '')
    let l:endtext = substitute(getline(v:foldend), '^\s*', '', '')
    if v:foldend - v:foldstart > 1
        let l:midtext = ' … '
    else
        let l:midtext = ' '
    endif
    let l:fulltext = l:starttext . l:midtext . l:endtext

    let l:numtext = '[' . (v:foldend - v:foldstart - 1) . ']'

    let l:spacesize = l:windowwidth - strwidth(l:fulltext) - strwidth(l:numtext)

    " If we have an overflow from two combined lines, just trim the first line
    if l:spacesize < 0
        let l:numtext = '[' . (v:foldend - v:foldstart) . ']'
        let l:fulltextlen = l:windowwidth - strwidth(l:numtext) - 3 " 3 = strwidth(' … ')
        let l:fulltext = strcharpart(l:starttext, 0, l:fulltextlen) . ' …'
        let l:spacesize = l:windowwidth - strwidth(l:fulltext) - strwidth(l:numtext)
    endif

    let l:spacetext = repeat(' ', l:spacesize)

    return l:fulltext . l:spacetext . l:numtext
endfunction


""""""""""""""
"  Filetype  "
""""""""""""""
augroup vimrc
    " Set fallback omnicompletion
    autocmd FileType *
                \ if &omnifunc == '' |
                \     setlocal omnifunc=syntaxcomplete#Complete |
                \ endif
augroup END


""""""""""""
"  Syntax  "
""""""""""""

vnoremap <Leader>X !xmllint --format --recover -<CR>


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
nnoremap <Leader>sv :source $MYVIMRC<CR>
nnoremap <Leader>ev :$tabedit ~/.vimrc<CR>

" Faster ESC
inoremap jk <ESC>
vnoremap jk <ESC>
" Commandline mode (<ESC> from a mapping actually executes the command!)
cnoremap jk <C-c>

function! g:CheckCmdWin()
    return getcmdwintype() !=# ''
endfunction
" Navigate splits
noremap <Leader>j <C-w>j
" The command window is a special case, we can't navigate out and must quit
" instead. This mapping is the only one likely to be called in this case.
noremap <silent> <expr> <Leader>k g:CheckCmdWin() ? ":q\<CR>" : "\<C-w>k"
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

" Faster window resizing
nnoremap <Leader>> :exe "vertical resize " . (winwidth(0) * 4/3)<CR>
nnoremap <Leader>< :exe "vertical resize " . (winwidth(0) * 3/4)<CR>

" vim-test mappings
map <Leader>t :TestFile<CR>
map <Leader>s :TestNearest<CR>
map <Leader>r :TestLast<CR>

" Search for visually-selected text
vnoremap / y/\V<C-R>=escape(@",'/\')<CR><CR>

nnoremap zh 5zh
nnoremap zl 5zl

" Make netrw-v open split on the right instead of left
let g:netrw_altv=1

" Split line under cursor (opposite of J)
nnoremap K i<CR><Esc>l

" Remap Ctrl+Slash to comment in insert mode
inoremap <C-_> <C-o>:Commentary<CR>

function! g:EnterWithoutComments()
    let l:orig_formatting = &formatoptions
    set formatoptions -=r

    " Enter insert mode, and perform our <Enter>. :normal implicitly adds
    " <Esc> at the end of an insert command, and <Enter><Esc> removes any
    " autoindenting, so we insert a dummy space to keep the indent.
    execute "normal! a\<CR>\<Space>\<BS>"

    let &formatoptions = l:orig_formatting
endfunction
" <Alt-Enter> on a comment line will force the next line to be regular text.
inoremap <silent> <A-CR> <C-c>:call EnterWithoutComments()<CR>I

" fzf mapping
nnoremap <C-p> :FZF<CR>
nnoremap <Leader>p :FZF<CR>
nnoremap <Leader>f :Buffers<CR>

" ALE mappings
nmap <silent> [w <Plug>(ale_previous_wrap)
nmap <silent> ]w <Plug>(ale_next_wrap)

" Close extraneous or temporary windows
function! g:CloseExtra()
    pclose
    cclose
    lclose
    " helpclose
endfunction

nnoremap <silent> <Leader>w :call g:CloseExtra()<CR>
nnoremap <Leader>W :tabc<CR>

nnoremap <Leader>m :MaximizerToggle!<CR>
vnoremap <Leader>m :MaximizerToggle!<CR>gv

" Vim doesn't normally fire events on suspend/resume, so hack around this and
" fire FocusLost/Gained events.
nnoremap <C-z> :doautocmd FocusLost \| suspend \| doautocmd FocusGained <CR>

nnoremap <silent> <A-v> :call vimterm#toggle() <CR>
tnoremap <silent> <A-v> <C-\><C-n>:call vimterm#toggle()<CR>
tnoremap <Esc> <C-\><C-n>

" Change gitgutter map prefix
nmap <Leader>gs <Plug>GitGutterStageHunk
nmap <Leader>gu <Plug>GitGutterUndoHunk
nmap <Leader>gp <Plug>GitGutterPreviewHunk

" See https://github.com/uptech/alt
function! AltCommand(path, command)
    let l:alternate_path = system("alt " . a:path)
    if empty(l:alternate_path)
        echoerr "No alternate file for " . a:path . " exists!"
    else
        exec a:command . " " . l:alternate_path
    endif
endfunction

nnoremap <Leader>x :call AltCommand(expand('%'), ':e')<CR>


"""""""""""""""""""""
"  Plugin Settings  "
"""""""""""""""""""""

" Maximizer settings
" Turn off mappings since we don't want them in insert mode
let g:maximizer_set_default_mapping = 0

" Splitjoin settings
let g:splitjoin_ruby_hanging_args = 0

runtime! vimrc.d/**/*.vim

call plug#end()
