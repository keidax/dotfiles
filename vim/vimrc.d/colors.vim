" Base16 colorschemes
Plug 'chriskempson/base16-vim'

" Set up highlight colors and attributes
" (The autocmds preserve our colors even if the colorscheme changes)
augroup vimrc
    " Transparent background colors
    au ColorScheme * :highlight Normal ctermbg=none

    " Better indent guide colors for base16 dark colorscheme
    au ColorScheme * :highlight IndentGuidesOdd  ctermbg=19 ctermfg=18
    au ColorScheme * :highlight IndentGuidesEven ctermbg=18 ctermfg=19

    " Muted colors for invisible characters
    au ColorScheme * call Base16hi('SpecialKey', g:base16_gui02, '', g:base16_cterm02, '')
    au ColorScheme * call Base16hi('NonText', g:base16_gui02, '', g:base16_cterm02, '')

    " Muted colors for vertical borders
    au ColorScheme * call Base16hi('VertSplit', g:base16_gui03, 'NONE', g:base16_cterm03, 'NONE')

    " Muted colors and underline for inactive statuslines
    au ColorScheme * call Base16hi('StatusLineNC', g:base16_gui03, 'NONE', g:base16_cterm03, 'NONE', 'underline')
    au ColorScheme * call Base16hi('StatusLine', g:base16_gui07, g:base16_gui02, g:base16_cterm07, g:base16_cterm02)

    " Red and bold
    au ColorScheme * call Base16hi('User1', g:base16_gui08, g:base16_gui02, g:base16_cterm08, g:base16_cterm02, 'bold')
    " Blue
    au ColorScheme * call Base16hi('User2', g:base16_gui0D, g:base16_gui02, g:base16_cterm0D, g:base16_cterm02, 'NONE')
    " Bold
    au ColorScheme * call Base16hi('User3', g:base16_gui04, g:base16_gui02, g:base16_cterm04, g:base16_cterm02, 'bold')

    " Italicised comments
    au ColorScheme * :highlight Comment cterm=italic " gui=italic
    au ColorScheme * :highlight Todo cterm=italic " gui=italic

    " More visible operators
    au ColorScheme * call Base16hi('Operator', g:base16_gui08, '', g:base16_cterm08, '')

    " Red highlight for extra whitespace
    au ColorScheme * call Base16hi( 'ExtraWhitespace', '', g:base16_gui08, '', g:base16_cterm08)

    " Bold for current quickfix item
    au ColorScheme * call Base16hi('QuickFixLine', '', '', '', '', 'bold')

    " Special highlighting for signs
    au ColorScheme * :highlight GitGutterChange cterm=bold
    au ColorScheme * :highlight ALEWarningSign ctermfg=3 ctermbg=18

    " More readable inline error messages
    au ColorScheme * :highlight link ALEVirtualTextWarning ALEWarningSign
    au ColorScheme * :highlight link ALEVirtualTextError Error

    " Some syntax files will highlight errors with a red background. Setting
    " the foreground to red as well makes errors unreadable. Underlining plus
    " gutter signs should be visible enough.
    au ColorScheme * :highlight ALEError cterm=underline

    " More readable spelling errors
    au ColorScheme * :highlight SpellCap ctermbg=none
    au ColorScheme * :highlight SpellBad ctermfg=9 ctermbg=none cterm=bold

    " Turn off default bold style for some groups when using GUI attributes
    au ColorScheme * :highlight Statement gui=none

    " Treesitter color adjustments
    " Partial workaround for https://github.com/nvim-treesitter/nvim-treesitter/issues/3396
    au ColorScheme * :highlight link @none Normal
    au ColorScheme * :highlight Normal gui=nocombine

    " Missing @symbol highlight group
    au ColorScheme * :highlight link @symbol @constant

    " Other tweaks
    au ColorScheme * :highlight link @string.special Special
    au ColorScheme * :highlight link @text.warning @text.todo
augroup END
