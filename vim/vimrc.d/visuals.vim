" General visual settings

" Skinny vertical borders
set fillchars=vert:│

" Display invisible characters
" EOL alternatives: ↲↵↩⤶
set listchars=eol:↩,tab:▸-,trail:~,extends:>,precedes:<,space:·

if !has('nvim')
    " Force escape sequences for italics, instead of messing with terminfo defs
    let &t_ZH="\e[3m"
    let &t_ZR="\e[23m"
endif

" Highlight trailing whitespace
Plug 'ntpeters/vim-better-whitespace'

" This doesn't actually turn off current line highlighting, but it does give a
" necessary performance boost.
" let g:current_line_whitespace_disabled_soft = 1
" let g:better_whitespace_verbosity = 1
" let g:better_whitespace_enabled = 1

" Visible indent levels
Plug 'nathanaelkane/vim-indent-guides'

" indent-guides options
let g:indent_guides_guide_size = 1
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_start_level = 2
" Allow our own indent guide colors to take effect
let g:indent_guides_auto_colors = 0
let g:indent_guides_exclude_filetypes = ['diff', 'git', 'gitcommit', 'help', 'man']
