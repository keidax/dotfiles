let b:ale_fixers = ['terraform']
let b:ale_fix_on_save = 1

let b:ale_linters = ['terraform']

setl foldmethod=expr
setl foldexpr=nvim_treesitter#foldexpr()
