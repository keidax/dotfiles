" Use JS folding
setlocal foldmethod=syntax

set shiftwidth=2

" Add ES6-style snippets for test files (works for Jest too)
if bufname('%') =~? '\.test\.jsx\?$'
    UltiSnipsAddFiletypes javascript-jasmine-arrow
endif

let b:ale_linters = ['eslint']
