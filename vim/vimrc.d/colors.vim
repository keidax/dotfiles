" Base16 colorschemes
Plug 'chriskempson/base16-vim'
" (We want it now!)
call plug#load('base16-vim')

" Set up highlight colors and attributes
" (The autocmds preserve our colors even if the colorscheme changes)
augroup vimrc
    " Transparent background colors
    autocmd ColorScheme * :highlight Normal ctermbg=none
    autocmd ColorScheme * :highlight VertSplit ctermbg=none
    autocmd ColorScheme * :highlight StatusLineNC ctermbg=none

    " Better indent guide colors for base16 dark colorscheme
    autocmd ColorScheme * :highlight IndentGuidesOdd  ctermbg=19 ctermfg=18
    autocmd ColorScheme * :highlight IndentGuidesEven ctermbg=18 ctermfg=19

    " Muted colors for invisible characters
    autocmd ColorScheme * :highlight SpecialKey ctermfg=19
    autocmd ColorScheme * :highlight NonText ctermfg=19

    " Muted colors for vertical borders
    autocmd ColorScheme * :highlight VertSplit ctermfg=8

    " Muted colors and underline for inactive statuslines
    autocmd ColorScheme * :highlight StatusLineNC cterm=italic,underline ctermfg=8
    " Bold emphasis for active statusline
    autocmd ColorScheme * :highlight StatusLine cterm=bold

    " Italicised comments
    autocmd ColorScheme * :highlight Comment cterm=italic
    autocmd ColorScheme * :highlight Todo cterm=italic

    " More visible operators
    autocmd ColorScheme * :highlight Operator ctermfg=1

    " Red highlight for extra whitespace
    " TODO better-whitespace should set this automatically
    " autocmd ColorScheme * :highlight ExtraWhitespace ctermbg=red

    " Different highlight for current quickfix item
    autocmd ColorScheme * :highlight QuickFixLine cterm=bold ctermbg=18

    " Special highlighting for signs
    autocmd ColorScheme * :highlight GitGutterChange cterm=bold
    autocmd ColorScheme * :highlight ALEWarningSign ctermfg=3 ctermbg=18

    " No annoying blue highlighting
    autocmd ColorScheme * :highlight SpellCap ctermbg=none
augroup END

" Use matching colorscheme from terminal theme
if filereadable(expand('~/.vimrc_background'))
    let g:base16colorspace=256
    let g:base16_shell_path=$DOTDIR . '/base16/base16-shell/scripts'
    source ~/.vimrc_background
endif
