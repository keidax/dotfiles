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
" Let vim-closetag work with XSD, XSLT files
let g:closetag_filenames = "*.xml,*.html,*.xsd,*.xsl"
Plug 'alvan/vim-closetag'
Plug 'airblade/vim-gitgutter'
Plug 'ntpeters/vim-better-whitespace'
Plug 'jiangmiao/auto-pairs'
Plug 'dahu/vim-fanfingtastic'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' } | Plug 'junegunn/fzf.vim'
Plug 'yonchu/accelerated-smooth-scroll'
Plug 'w0rp/ale'
Plug 'vim-ruby/vim-ruby'
Plug 'tpope/vim-rails'
Plug 'Valloric/YouCompleteMe', { 'do': './install.py' }
Plug 'step-/securemodelines'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'vim-utils/vim-man'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-surround'
Plug 'mileszs/ack.vim'
" Better performance on e.g. large Ruby files
Plug 'Konfekt/FastFold'
Plug 'kana/vim-textobj-user'
Plug 'nelstrom/vim-textobj-rubyblock'

" Set modern alt/meta mappings: most modern terminals will output Alt-x as Esc-x
" instead of setting the meta bit. This plugin updates Vim's expectations.
"
" In iTerm2, this requires the "Esc+" setting for the Option keys (since Macs
" use Option+key for different characters).
Plug 'drmikehenry/vim-fixkey'
call plug#end()

"""""""""""""
"  General  "
"""""""""""""

augroup vimrc
    " Clear previously-set local autocommands
    au!
    " Reload vimrc on write
    autocmd BufWritePost $MYVIMRC,*/{.,}dotfiles/vimrc :source $MYVIMRC | doauto VimEnter
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

" Commandline completion fills in longest common substring, then cycles options
set wildmode=longest:full,full

" Go to the previous tab instead of the next when closing a tab
augroup vimrc
    autocmd TabClosed * :tabprevious
augroup END

" New windows open where expected
set splitbelow splitright

""""""""""""
"  Visual  "
""""""""""""

" Set up highlight colors and attributes
" (The autocmds preserve our colors even if the colorscheme changes)
augroup vimrc
    " Use matching colorscheme from terminal theme, only on startup
    autocmd VimEnter *
                \ if filereadable(expand("~/.vimrc_background")) |
                \     let base16colorspace=256 |
                \     let g:base16_shell_path="~/.dotfiles/base16/base16-shell/scripts" |
                \     source ~/.vimrc_background |
                \ endif

    " Transparent background colors
    autocmd VimEnter,ColorScheme * :highlight Normal ctermbg=none
    autocmd VimEnter,ColorScheme * :highlight VertSplit ctermbg=none
    autocmd VimEnter,ColorScheme * :highlight StatusLineNC ctermbg=none

    " Better indent guide colors for base16 dark colorscheme
    autocmd VimEnter,Colorscheme * :highlight IndentGuidesOdd  ctermbg=19 ctermfg=18
    autocmd VimEnter,Colorscheme * :highlight IndentGuidesEven ctermbg=18 ctermfg=19

    " Muted colors for invisible characters
    autocmd VimEnter,ColorScheme * :highlight SpecialKey ctermfg=19
    autocmd VimEnter,ColorScheme * :highlight NonText ctermfg=19

    " Muted colors for vertical borders
    autocmd VimEnter,ColorScheme * :highlight VertSplit ctermfg=8

    " Muted colors and underline for inactive statuslines
    autocmd VimEnter,ColorScheme * :highlight StatusLineNC cterm=italic,underline ctermfg=8
    " Bold emphasis for active statusline
    autocmd VimEnter,ColorScheme * :highlight StatusLine cterm=bold

    " Italicised comments
    autocmd VimEnter,ColorScheme * :highlight Comment cterm=italic
    autocmd VimEnter,ColorScheme * :highlight Todo cterm=italic

    " More visible operators
    autocmd VimEnter,Colorscheme * :highlight Operator ctermfg=1

    " Red highlight for extra whitespace
    " TODO better-whitespace should set this automatically
    autocmd VimEnter,ColorScheme * :highlight ExtraWhitespace ctermbg=red
augroup END

" Skinny vertical borders
set fillchars=vert:│

" Display invisible characters
" EOL alternatives: ↲↵↩⤶
set listchars=eol:↩,tab:▸-,trail:~,extends:>,precedes:<,space:·

" Force escape sequences for italics, instead of messing with terminfo defs
let &t_ZH="\e[3m"
let &t_ZR="\e[23m"

" Turn off all folds by default
set nofoldenable
" For filetypes with folding enabled, don't start completely folded
set foldlevelstart=2

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
    " Use real tabs in makefiles, and turn off all spaces
    autocmd FileType make setlocal noexpandtab shiftwidth=0 tabstop=8 softtabstop=0

    " Use standard indentation and line size for Ruby files. The old RE engine
    " also seems to give better performance for Ruby syntax highlighting
    autocmd FileType ruby setlocal shiftwidth=2 softtabstop=2 colorcolumn=101 foldenable regexpengine=1

    " Use recommended 2-space indent for YAML files
    autocmd FileType yaml setlocal expandtab shiftwidth=2 softtabstop=2

    " Use 2-space indent for XML and family
    autocmd FileType xml,xsd,xslt setlocal expandtab shiftwidth=2 softtabstop=2
    " Formatting with xmllint
    autocmd FileType xml,xsd,xslt setlocal equalprg=xmllint\ --format\ --recover\ -

    " Use shell folding
    autocmd FileType sh setlocal foldenable

    " Set fallback omnicompletion
    autocmd FileType *
                \ if &omnifunc == '' |
                \     setlocal omnifunc=syntaxcomplete#Complete |
                \ endif
augroup END


""""""""""""
"  Syntax  "
""""""""""""

" Ruby syntax settings
let g:ruby_fold = 1
let g:ruby_foldable_groups = 'ALL'

" Shell syntax settings
let g:sh_fold_enabled = 7   " Enable all types of folding
let g:is_posix = 1          " We can assume /bin/sh is POSIX-compatible


" Expand and format XML by selecting it and pressing <Leader><Shift-X>
function! XMLLint() range
    execute a:firstline . ',' . a:lastline . '!xmllint --format --recover -'
endfunction

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

" Faster window resizing
nnoremap <Leader>> :exe "vertical resize " . (winwidth(0) * 4/3)<CR>
nnoremap <Leader>< :exe "vertical resize " . (winwidth(0) * 3/4)<CR>

" vim-rspec mappings
map <Leader>t :call RunCurrentSpecFile()<CR>
map <Leader>T :silent call system("spring stop") \| :call RunCurrentSpecFile()<CR>
map <Leader>s :call RunNearestSpec()<CR>
map <Leader>r :call RunLastSpec()<CR>

" Search for visually-selected text
vnoremap / y/\V<C-R>=escape(@",'/\')<CR><CR>

" Load quickfix window in a new tab, and reuse that tab
set switchbuf=usetab,newtab

function! SwitchOrOpenQF()
    for i in range(tabpagenr('$'))
        for j in range(tabpagewinnr(i + 1, '$'))
            let l:found_qf = gettabwinvar(i + 1, j + 1, "quickfix_title")
            let l:fil = @%
            if found_qf != "" && found_qf =~# @%
                exe "tabn ".(i+1)
                exe (j+1)."wincmd w"
                set nowrap
                return
            endif
        endfor
    endfor
    " Didn't find the right quickfix window, so open a new one
    belowright copen
    set nowrap
endfunction

" When running vim-rspec
augroup vimrc
    autocmd User AsyncRunStart :call SwitchOrOpenQF()
augroup END

" Make netrw-v open split on the right instead of left
let g:netrw_altv=1

" Split line under cursor (opposite of J)
nnoremap K i<CR><Esc>l

" Remap Ctrl+Slash to comment in insert mode
inoremap <C-_> <C-o>:Commentary<CR>

" fzf mapping
nnoremap <C-p> :FZF<CR>
nnoremap <Leader>p :FZF<CR>

" ALE mappings
nmap <silent> [w <Plug>(ale_previous_wrap)
nmap <silent> ]w <Plug>(ale_next_wrap)


"""""""""""""""""""""
"  Plugin Settings  "
"""""""""""""""""""""

" vim-rspec settings

" Run rspec with color forced on, through spring, asynchronously, sending
" output to the quickfix window
let g:rspec_command = ":AsyncRun bin/rspec {spec}"

" Configure vim-indent-guides
let g:indent_guides_guide_size = 1
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_start_level = 2
" Allow our own indent guide colors to take effect
let g:indent_guides_auto_colors = 0

let g:ac_smooth_scroll_du_sleep_time_msec=0
let g:ac_smooth_scroll_fb_sleep_time_msec=0

" ALE settings
let g:ale_sign_error = ''
let g:ale_sign_warning = ''
" Various linter settings
let g:ale_ruby_rubocop_options = '-D -R -E'
let g:ale_linters_sh_shellcheck_exclusions = 'SC1090,SC1091'

" GitGutter settings
augroup vimrc
    autocmd VimEnter,Colorscheme * :highlight GitGutterChange cterm=bold
    autocmd VimEnter,Colorscheme * :highlight GitGutterChangeDelete cterm=bold
augroup END
let g:gitgutter_sign_removed = '▁▁'
let g:gitgutter_sign_removed_first_line = '▔▔'
let g:gitgutter_sign_added = '' "octicons (shifted in nerd font)
let g:gitgutter_sign_modified = '~~'
let g:gitgutter_sign_modified_removed = '≃≃'

" Securemodelines options
set nomodeline " Silence warning on startup
let g:secure_modelines_verbose = 1

" better-whitespace options
" This doesn't seem to actually turn off current line highlighting, but it
" does give a necessary performance boost.
let g:current_line_whitespace_disabled_soft = 1
let g:better_whitespace_verbosity = 1
