" Use 2-space indent for XML and family
setlocal shiftwidth=2
" Use folding
setlocal foldmethod=syntax

" Use tidy as a fixer
" TODO: may need more configuration
let b:ale_fixers = ['tidy']
let b:ale_xml_xmllint_indentsize = 2
