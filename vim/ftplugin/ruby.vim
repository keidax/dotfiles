" Use standard indentation and line size for Ruby files.
setlocal shiftwidth=2 softtabstop=2
" Suggest 100-char limit
setlocal colorcolumn=81,101
" Use folding
setlocal foldenable
" The old RE engine also seems to give better performance for Ruby syntax highlighting
setlocal regexpengine=1
" !, ?, and = can end method names
setlocal iskeyword+=?,!,=

" Check spelling (see after/syntax/ruby.vim for more details)
setlocal spell
