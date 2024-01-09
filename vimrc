call plug#begin($DOTDIR . '/vim/plugged')
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
Plug 'kana/vim-textobj-user'
Plug 'voldikss/vim-floaterm'

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
Plug 'tpope/vim-unimpaired'
Plug 'junegunn/vim-easy-align'
Plug 'mbbill/undotree'
Plug 'tpope/vim-projectionist'

Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'simrat39/rust-tools.nvim'

" Improve blockwise copy/paste in Neovim.
" See https://github.com/neovim/neovim/issues/1822
" The issue is fixed for a single running instance, but this plugin still
" helps when pasting between Neovim instances.
Plug 'bfredl/nvim-miniyank'
nmap p <Plug>(miniyank-autoput)
xmap p <Plug>(miniyank-autoput)
nmap P <Plug>(miniyank-autoPut)
xmap P <Plug>(miniyank-autoPut)
nmap - <Plug>(miniyank-cycle)
nmap + <Plug>(miniyank-cycleback)

Plug 'ojroques/vim-oscyank', {'branch': 'main'}
let g:clipboard = {
        \   'name': 'osc52',
        \   'copy': {
        \     '+': {lines, regtype -> OSCYank(join(lines, "\n"))},
        \     '*': {lines, regtype -> OSCYank(join(lines, "\n"))},
        \   },
        \   'paste': {
        \     '+': {-> [split(getreg(''), '\n'), getregtype('')]},
        \     '*': {-> [split(getreg(''), '\n'), getregtype('')]},
        \   },
        \ }

if has('nvim-0.5.0')
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
endif


"""""""""""""
"  General  "
"""""""""""""

augroup vimrc
    " Clear previously-set local autocommands
    au!
    " Reload vimrc on write
    autocmd BufWritePost $MYVIMRC,*/{.,}vimrc :source $MYVIMRC | doauto VimEnter

    " Jump to previous cursor location when opening or switching to buffers
    autocmd BufReadPost,BufEnter *
                \ if &bt !=# 'terminal' && line("'\"") > 0  && line("'\"") < line('$')|
                \   exe 'normal g`"' |
                \ endif
    " Save cursor location when switching away from a buffer
    autocmd BufLeave *
                \ if &bt !=# 'terminal' |
                \   exe 'normal m"' |
                \ endif
augroup END

" Set indentation settings
set expandtab       " Spaces are used instead of tab characters
set tabstop=8       " This should be 8 for compatibility purposes
set shiftwidth=4    " Shifts (>>, etc.) move by 4 spaces
set softtabstop=-1  " <Tab> inserts {shiftwidth} spaces

" Don't act like sentences end with two spaces.
set nojoinspaces

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

" Preview substitutions in a split window
set inccommand=split

""""""""""""
"  Visual  "
""""""""""""

" Turn off all folds by default
set nofoldenable
" Intended folding flow:
" - open a new file, all folds are expanded
" - `zi` to turn on folding at the default level (1)
" - `zM` to close all folds
augroup vimrc
    " Folds start off, but leave the first level of folds open if folding is
    " switched on. We have to use an autocmd because 'foldlevelstart' is
    " also applied when switching to a loaded buffer.
    autocmd BufReadPost * setl foldlevel=1
augroup END

set foldtext=MyFoldText()
" Inspired by https://coderwall.com/p/usd_cw/a-pretty-vim-foldtext-function
function! MyFoldText()
    let l:padding = &foldcolumn + &number * &numberwidth

    " Test if any signs exist
    let l:signs = sign_getplaced('%', { 'group': '*' })[0]['signs']

    let l:padding += len(l:signs) > 0 ? 2 : 0

    let l:windowwidth = winwidth(0) - l:padding
    let l:windowwidth = min([l:windowwidth, 100])

    let l:starttext = substitute(getline(v:foldstart), '\s*$', '', '')
    " Expand tabs (otherwise foldtext will collapse them to one space)
    let l:starttext = substitute(l:starttext, '\t', repeat(' ', &tabstop), 'g')

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

augroup vimrc_local
    " Clear previously-set local autocommands
    au!

    autocmd BufEnter ~/src/tree-sitter-crystal/*.cr let b:ale_fix_on_save=0
    autocmd BufEnter ~/src/tree-sitter-crystal/*.js let b:ale_fix_on_save=1 | let b:ale_fixers = ['eslint']
    autocmd BufEnter ~/src/tree-sitter-crystal/src/scanner.c let b:ale_fix_on_save=1 | let b:ale_fixers = ['clang-format']

    " For rendering-api-testing-framework, make sure jest runs with correct
    " project options
    autocmd BufEnter ~/code/rendering-api-testing-framework/*.js
        \ let g:test#javascript#jest#executable = 'npm run test:unit --'

    autocmd BufEnter ~/code/browser-testing-framework/*.js
        \ let g:test#javascript#mocha#executable = 'npm run test:unit --'
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
map <silent> <Leader>t :update \| TestFile<CR>
map <silent> <Leader>s :update \| TestNearest<CR>
map <silent> <Leader>r :update \| TestLast<CR>

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

" Clear buffer on ZZ/ZQ
" (double exec avoids using a global variable)
nnoremap <silent> ZZ
    \ :exec 'exec "normal! ZZ" \| bd ' . bufnr('%')<CR>
nnoremap <silent> ZQ
    \ :bd!<CR>

" alias for ZQ that's easier to type for a bunch of buffers in a row
nmap QQ ZQ

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

nnoremap <A-f> :FloatermToggle<CR>
if has('nvim')
    tnoremap <silent> <A-f> <C-\><C-n>:FloatermToggle<CR>
    tnoremap <Esc> <C-\><C-n>
endif

" After using Fugitive to go back through the git history and inspect
" different commits, this mapping offers a quick way to return to the file
" most recently being worked on. (The alternative is pressing <C-O> an
" arbitrary number of times.)
func! JumpToPrevNonGitBuffer()
    let [jumplist, jumpnum] = getjumplist()
    let relevant_jumplist = jumplist[:(jumpnum - 1)]

    let count=1

    for jumpitem in reverse(relevant_jumplist)
        if buflisted(jumpitem.bufnr) && bufname(jumpitem.bufnr) !~# "^fugitive://"
            execute "normal " . count . "\<c-o>"
            return
        endif

        let count+=1
    endfor
endfunc
nnoremap <silent> <Leader>gb :call JumpToPrevNonGitBuffer()<CR>

" Change gitgutter map prefix
xmap <Leader>gs <Plug>(GitGutterStageHunk)
nmap <Leader>gs <Plug>(GitGutterStageHunk)
nmap <Leader>gu <Plug>(GitGutterUndoHunk)
nmap <Leader>gp <Plug>(GitGutterPreviewHunk)

" Show full diffconflict context
nnoremap <Leader>D :DiffConflictsShowHistory<CR>

" Alt-k starts a fzf search for current word
nnoremap <A-k> :Rg <C-r>=expand("<cword>")<CR><CR>

" A nicer version of z=
func! FzfSpellReplace() abort
    if !&spell
        echohl ErrorMsg
        echomsg 'Spell checking is not enabled'
        echohl None
        return
    endif

    " TODO: figure out why setting 'window' dict changes the cursor?
    call fzf#run({
        \ 'source': spellsuggest(expand('<cword>'), 30),
        \ 'sink': { word -> execute('normal! ciw'.word) },
        \ 'options': ['--prompt', 'Change '''.expand('<cword>').''' to: ', '--no-bold'],
        \ 'down': '~30%',
        \ })
endfunc
nnoremap <silent> <Leader>z :call FzfSpellReplace()<CR>

" Let Backspace remove the last digit in a partial count
nnoremap <expr> <BS> (v:count ? '<Del>' : '<BS>')

" Use <count><Enter> as a shortcut for :<count><Enter>
nnoremap <expr> <CR> (v:count ? 'G' : '<CR>')

" The indent-blankline plugin doesn't know when folds are revealed, so we need
" to supplement the builtin fold mappings.
" https://github.com/lukas-reineke/indent-blankline.nvim/issues/449
for foldmap in [
    \ 'zo',
    \ 'zO',
    \ 'zc',
    \ 'zC',
    \ 'za',
    \ 'zA',
    \ 'zv',
    \ 'zx',
    \ 'zX',
    \ 'zm',
    \ 'zM',
    \ 'zr',
    \ 'zR',
    \ 'zn',
    \ 'zN',
    \ 'zi'
    \]

    call nvim_set_keymap('n', foldmap, foldmap . '<CMD>IndentBlanklineRefresh<CR>', {
        \ 'noremap': v:true,
        \ 'silent': v:true,
        \ 'desc': 'Fold while refreshing indent guides'})
endfor

" Disable plugin mappings that are covered below
let g:endwise_no_mappings = 1
let g:UltiSnipsRemoveSelectModeMappings = 0
let g:AutoPairsMapCR = 0
let g:UltiSnipsExpandTrigger = '<NUL>'
let g:UltiSnipsListSnippets = '<NUL>'

xmap <Leader>a <Plug>(EasyAlign)
nmap <Leader>a <Plug>(EasyAlign)

" Quick writing
nnoremap <silent> <Leader>w :update<CR>

" Use Ctrl-J/K as alternatives to arrow keys for matching history searches
cnoremap <C-j> <Down>
cnoremap <C-k> <Up>

cnoremap <C-a> <Home>
cnoremap <C-e> <End>

" Avoid Ex mode
nnoremap Q <nop>

"""""""""""""""""""""
"  Plugin Settings  "
"""""""""""""""""""""

" Options to control vim-plug
" Open diffs in a new tab
let g:plug_pwindow = 'tabe'


" Maximizer settings
" Turn off mappings since we don't want them in insert mode
let g:maximizer_set_default_mapping = 0

" Splitjoin settings
let g:splitjoin_ruby_hanging_args = 0
let g:splitjoin_ruby_options_as_arguments = 1

" Jump to existing window with :Buffers
let g:fzf_buffers_jump = 1

runtime! vimrc.d/**/*.vim

call plug#end()

" Use matching colorscheme from terminal theme
if filereadable(expand('~/.vimrc_background'))
    if $TERM =~ 'konsole.*'
        " No 256 colorspace
        set termguicolors
    else
        let g:base16colorspace=256
        let g:base16_shell_path=$DOTDIR . '/base16/base16-shell/scripts'
    endif

    if $BASE16_THEME =~? 'dark'
        set background=dark
    else
        set background=light
    endif

    source ~/.vimrc_background
endif

lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = { "hcl" },
  highlight = {
    enable = true
  },
  indent = {
    enable = true
  },
}
EOF

lua <<EOF
  -- Set up nvim-cmp.
  local cmp = require'cmp'
  local cmp_ultisnips_mappings = require("cmp_nvim_ultisnips.mappings")

  cmp.setup({
    snippet = {
      expand = function(args)
         vim.fn["UltiSnips#Anon"](args.body)
      end,
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = false }),
      ["<Tab>"] = cmp.mapping(
        function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          else
            cmp_ultisnips_mappings.expand_or_jump_forwards(fallback)
          end
        end,
        { "i", "s", --[[ "c" (to enable the mapping in command mode) ]] }
      ),
      ["<S-Tab>"] = cmp.mapping(
        function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          else
            cmp_ultisnips_mappings.jump_backwards(fallback)
          end
        end,
        { "i", "s", --[[ "c" (to enable the mapping in command mode) ]] }
      ),
      ['<C-s>'] = cmp.mapping(
        function(fallback)
          cmp_ultisnips_mappings.compose { "expand" }(fallback)
        end,
        { "i", "s", --[[ "c" (to enable the mapping in command mode) ]] }
      )
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'ultisnips' },
      { name = 'path' },
      {
        name = 'buffer',
        option = {
                  -- Pull suggestions from all buffers
          get_bufnrs = function()
            return vim.api.nvim_list_bufs()
          end
        }
      },
    })
  })


  -- Enable the following language servers
  --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
  --
  --  Add any additional override configuration in the following tables. They will be passed to
  --  the `settings` field of the server config. You must look up that documentation yourself.
  local servers = {
    -- clangd = {},
    -- gopls = {},
    -- pyright = {},
    -- rust_analyzer = {},
    -- tsserver = {},

    solargraph = {},

    lua_ls = {
      Lua = {
        workspace = { checkThirdParty = false },
        telemetry = { enable = false },
      },
    },
  }

  local on_attach = function(client, bufnr)

    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local bufopts = { noremap=true, silent=true, buffer=bufnr }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    vim.keymap.set('n', '<space>d', vim.lsp.buf.hover, bufopts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
    vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  end

  -- Set up mason
  require("mason").setup()
  local mason_lspconfig = require("mason-lspconfig")
  mason_lspconfig.setup {
    ensure_installed = vim.tbl_keys(servers)
  }

  -- LSP setup
  local lspconfig = require('lspconfig')
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

  mason_lspconfig.setup_handlers {
    function(server_name)
      lspconfig[server_name].setup {
        capabilities = capabilities,
        settings = servers[server_name],
        on_attach = on_attach,
      }
    end,

    ["rust_analyzer"] = function ()
      require("rust-tools").setup {
        server = {
            capabilities = capabilities,
            on_attach = on_attach,
        }
      }
    end
  }
EOF
