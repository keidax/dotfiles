" Regenerate spell files as needed
Plug 'micarmst/vim-spellsync'

" NOTE: Spell checking is turned on for individual filetypes in ftplugin files.

" Don't complain about missing capitals (doesn't work well with code)
set spellcapcheck=
" Set up 2 spelling lists
set spellfile=$DOTDIR/vim/spell/en.utf-8.add,$DOTDIR/vim/spell/local.utf-8.add

" Notes:
" - @Spell/@NoSpell clusters don't seem to have an effect on nested groups.
" - If _only_ @NoSpell clusters are used, then all other groups will
"   implicitly be spell checked. (see :h spell-syntax)
" - contains=TOP,@Spell breaks all spell checking?
