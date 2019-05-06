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
Plug 'junegunn/vim-easy-align'


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

" ...unless we want uppercase
set smartcase

" Highlight search results (can be cleared with Ctrl+L)
set hlsearch

" Cut-and-paste operations use the system clipboard
set clipboard=unnamed,unnamedplus

" Faster update time (pick up changes in vim-gitgutter)
set updatetime=250

" Commandline completion fills in longest common substring, then cycles options
set wildmode=longest:full,full

" Completion won't fill the whole screen
set pumheight=20

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
" Leader
let mapleader = " "

" Quickly edit and source vimrc
nnoremap <Leader>vs :source $MYVIMRC<CR>
nnoremap <Leader>ve :$tabedit ~/.vimrc<CR>

" Faster ESC
inoremap jk <ESC>
vnoremap jk <ESC>
" Commandline mode (<ESC> from a mapping actually executes the command!)
cnoremap jk <C-c>

" Let Alt+hjkl act as arrow keys in insert & command-line modes
noremap! <A-j> <Down>
noremap! <A-k> <Up>
noremap! <A-h> <Left>
noremap! <A-l> <Right>

" Don't let autopairs clobber C-h
let g:AutoPairsMapCh = 0

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

" Same-width/height windows
nnoremap <Leader>nh :leftabove  vnew<CR>
nnoremap <Leader>nj :rightbelow  new<CR>
nnoremap <Leader>nk :leftabove   new<CR>
nnoremap <Leader>nl :rightbelow vnew<CR>

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
" fire FocusLost/Gained events. Check with `exists` first to avoid a "No
" matching autocommands" message
function! SuspendWithEvents()
    if exists('#FocusLost')
        doautocmd FocusLost
    endif
    suspend
    if exists('#FocusGained')
        doautocmd FocusGained
    endif
endfunction
nnoremap <silent> <C-z> :call SuspendWithEvents() <CR>

nnoremap <silent> <A-v> :call vimterm#toggle() <CR>
if has('nvim')
    tnoremap <silent> <A-v> <C-\><C-n>:call vimterm#toggle()<CR>
    tnoremap <Esc> <C-\><C-n>
endif

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

nnoremap <silent> <Leader>x :call AltCommand(expand('%'), ':silent e')<CR>
nnoremap <silent> <Leader>X :call AltCommand(expand('%'), ':silent sp')<CR>

" Show full diffconflict context
nnoremap <Leader>D :DiffConflictsShowHistory<CR>

" Alt-k starts a fzf search for current word
nnoremap <A-k> :Rg <C-r>=expand("<cword>")<CR><CR>

" Cross-plugin compatibility mappings
" Overview
" Enter:
"   - if completing and an item is selected, insert/expand
"   - if in a snippet, jump to next placeholder
"   - else, trigger other plugin behavior (endwise, autopairs)
" Tab:
"   - if completing, go to next item
"   - if in a snippet, jump to next placeholder
"   - if preceding whitespace, use normal tab behavior
"   - else, start completion
" Shift-Tab:
"   - if completing, go to previous item
"   - if in a snippet, jump to previous placeholder
"   - else, use normal Shift-Tab behavior
" Ctrl-J:
"   - if in a snippet, jump to next placeholder
"   - else, use normal Ctrl-J behavior
" Ctrl-K:
"   - if in a snippet, jump to previous placeholder
"   - else, use normal Ctrl-K behavior
" Ctrl-N: next completion item
" Ctrl-P: previous completion item
" Ctrl-S: expand or list snippets

" Explicit defaults for above behavior
let g:coc_snippet_next = '<C-j>'
let g:coc_snippet_prev = '<C-k>'

" Disable plugin mappings that are covered below
let g:endwise_no_mappings = 1
let g:UltiSnipsRemoveSelectModeMappings = 0
let g:AutoPairsMapCR = 0
let g:UltiSnipsExpandTrigger = '<NUL>'
let g:UltiSnipsListSnippets = '<NUL>'

" True if the cursor is preceded by whitespace
function! s:check_back_space() abort
    let l:col = col('.') - 1
    return !l:col || getline('.')[l:col - 1] =~# '\s'
endfunction

" Handle jumping backwards and forwards between snippet placeholders
function! SnippetJumpOnKey(forwards, fallback)
    " Note that this is false if we're on the final placeholder
    if coc#jumpable()
        call coc#rpc#request(a:forwards ? 'snippetNext' : 'snippetPrev', [])
        return ''
    elseif type(a:fallback) == v:t_func
        return a:fallback()
    else
        return a:fallback
    endif
endfunction

" Gracefully combine endwise and autopairs <Enter> functionality
function! EnterFallback()
    let l:ret = "\<CR>"
    let l:post_return = ["EndwiseDiscretionary()", "AutoPairsReturn()"]

    " FIXME For some reason, returning
    " <C-r>=EndwiseDiscretionary<CR><C-r>=anything<CR> seems to cause a sort
    " of nested insert mode when endwise is triggered -- I have to press <Esc>
    " twice to get back to normal mode. Combining the calls into one register
    " call avoids the issue.
    return l:ret . "\<C-r>=" . join(l:post_return, ".") . l:ret
endfunction

" When working inside a snippet, <Enter> will jump to the next placeholder.
" Otherwise it behaves as expected, with functionality combined from several
" plugins.
function! EnterCombined()
    if pumvisible() && coc#rpc#request('hasSelected', [])
        return "\<C-y>"
    endif
    return SnippetJumpOnKey(1, function('EnterFallback'))
endfunction

inoremap <silent> <CR> <C-r>=EnterCombined()<CR>
snoremap <silent> <CR> <Esc>:call EnterCombined()<CR>

" Cycle completion on Tab. If following whitespace, normal Tab behavior. If
" inside a snippet, jump to the next placeholder
function! TabCombined()
    if pumvisible()
        return "\<C-n>"
    else
        return SnippetJumpOnKey(1, { -> s:check_back_space() ? "\<Tab>" : coc#refresh() })
    endif
endfunction
inoremap <silent> <TAB> <C-r>=TabCombined()<CR>

" Reverse cycle completion on Shift-Tab, or jump to the previous snippet
" placeholder.
function! ShiftTabCombined()
    if pumvisible()
        return "\<C-p>"
    else
        return SnippetJumpOnKey(0, "\<S-Tab>")
    endif
endfunction
inoremap <silent> <S-Tab> <C-r>=ShiftTabCombined()<CR>

" When in Select mode inside a snippet, <Tab> and <Shift-Tab> will jump between
" placeholders.
snoremap <silent> <Tab> <Esc>:call SnippetJumpOnKey(1, "\<Tab>")<CR>
snoremap <silent> <S-Tab> <Esc>:call SnippetJumpOnKey(0, "\<S-Tab>")<CR>

" NOTE: In this case it's necessary to use the <C-r>=expr<CR> hack instead of
" map <expr> because the latter prevents changing the buffer text.
imap <silent> <C-s> <C-r>=coc#rpc#request('doKeymap', ['snippets-expand'])<CR>

nnoremap <silent> <Leader>d :call CocActionAsync('doHover')<CR>

xmap <Leader>a <Plug>(EasyAlign)
nmap <Leader>a <Plug>(EasyAlign)

" Quick writing
nnoremap <Leader>w :update<CR>

" Add a warning to learn the new mapping
cnoreabbrev w W
command! -bang -nargs=* W echoerr 'Use <lt>Leader>w instead!'

"""""""""""""""""""""
"  Plugin Settings  "
"""""""""""""""""""""

" Maximizer settings
" Turn off mappings since we don't want them in insert mode
let g:maximizer_set_default_mapping = 0

" Splitjoin settings
let g:splitjoin_ruby_hanging_args = 0
let g:splitjoin_ruby_options_as_arguments = 1

" Set up :Rg[!] command for fzf search with ripgrep.
" Use the bang for a full search into hidden, ignored, and symlinked files.
let s:rg_normal_opts = 'rg --vimgrep --smart-case --color=always '
let s:rg_bang_opts = s:rg_normal_opts . '--follow --hidden --no-ignore '
command! -bang -nargs=* Rg
    \ call fzf#vim#grep(
    \   (<bang>0 ? s:rg_bang_opts : s:rg_normal_opts) . shellescape(<q-args>),
    \   1)

runtime! vimrc.d/**/*.vim

call plug#end()
