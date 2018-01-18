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

" better-whitespace options
let g:better_whitespace_verbosity = 1
" This doesn't actually turn off current line highlighting, but it does give a
" necessary performance boost.
let g:current_line_whitespace_disabled_soft = 1
