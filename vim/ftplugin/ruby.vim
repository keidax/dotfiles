" Use standard indentation and line size for Ruby files.
setlocal shiftwidth=2 softtabstop=2
" Suggest 100-char limit
setlocal colorcolumn=81,101
" The old RE engine also seems to give better performance for Ruby syntax highlighting
setlocal regexpengine=1
" !, ?, and = can end method names
setlocal iskeyword+=?,!,=

" Syntax-based folding is too slow, let's try this
setlocal foldmethod=indent

" Check spelling (see after/syntax/ruby.vim for more details)
setlocal spell

let b:surround_68 = "do\n\r end"
