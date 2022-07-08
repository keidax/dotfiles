" JS folding
if has('nvim-0.5.0')
    setlocal foldmethod=expr
    setlocal foldexpr=nvim_treesitter#foldexpr()
else
    setlocal foldmethod=syntax
end

setlocal shiftwidth=2

" Add ES6-style snippets for test files (works for Jest too)
if bufname('%') =~? '\.test\.jsx\?$'
    UltiSnipsAddFiletypes javascript-jasmine-arrow
endif

let b:ale_linters = ['eslint']
