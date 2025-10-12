setlocal shiftwidth=2 softtabstop=2

" Run crystal formatter on save
let b:ale_fix_on_save = 1
let b:ale_fixers = [{ -> {
    \ 'command': 'crystal tool format %t',
    \ 'read_temporary_file': 1
    \ } }]
