" Vim syntax file for tree-sitter syntax tests

if exists('b:current_syntax')
  finish
endif

syn region  tsCorpusHeader matchgroup=tsCorpusDelimiter start="^=\+$" end="^=\+$" nextgroup=tsCorpusInput skipnl
syn region  tsCorpusInput start="\_." matchgroup=tsCorpusDelimiter end=/---\+/ contained nextgroup=tsCorpusNode skipempty
syn region  tsCorpusNode matchgroup=tsCorpusParens start="(" end=")" contains=tsCorpusNode,tsCorpusNodeName,tsCorpusNodeField
syn match   tsCorpusNodeName "\%((\)\@1<=[^[:space:]():]\+" contained
syn match   tsCorpusNodeField "[a-z_]\+:" contained

syn sync minlines=10 maxlines=500 match tsCorpusInputSync grouphere tsCorpusInput "^=\+$"

hi def link tsCorpusHeader      Title
hi def link tsCorpusInput       String
hi def link tsCorpusNodeName    Function
hi def link tsCorpusNodeField   Label
hi def link tsCorpusDelimiter   Delimiter
hi def link tsCorpusParens      Operator
