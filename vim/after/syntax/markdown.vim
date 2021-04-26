" Make COC previews look closer to rendered content
if &previewwindow
    " Match RDoc-style +code+
    syn region mkdCode matchgroup=mkdCodeDelimiter start=/\(\([^\\]\|^\)\\\)\@<!+/ end=/+/ concealends
    " Match <tt> tags
    syn region mkdCode matchgroup=mkdCodeDelimiter start=/<tt[^>]*\\\@<!>/ end=+</tt>+  concealends

    " Make code stand out a bit more
    hi mkdCode ctermfg=2 ctermbg=18

    " Handle HTML encoded signatures
    syn match htmlSpecialConcealed "&gt;" conceal cchar=> containedin=htmlSpecialChar
    syn match htmlSpecialConcealed "&lt;" conceal cchar=< containedin=htmlSpecialChar

    " Clear color for ligatures
    hi clear Conceal

    " Actual italics and bolds
    hi htmlItalic cterm=italic
    hi htmlBold cterm=bold
endif
