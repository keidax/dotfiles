
let g:most_recent_mode = ''
let g:mode_settings = {
    \ 'n':  ['Normal ', 'ctermbg=20 ctermfg=19'],
    \ 'i':  ['Insert ', 'ctermbg=02 ctermfg=19'],
    \ 'v':  ['Visual ', 'ctermbg=04 ctermfg=19'],
    \ 'V':  ['V Line ', 'ctermbg=04 ctermfg=19'],
    \ '': ['V Block', 'ctermbg=04 ctermfg=19'],
    \ 's':  ['Select ', ''],
    \ 'R':  ['Replace', ''],
    \ 'c':  ['Command', 'ctermbg=03 ctermfg=19'],
    \ 't':  [' Term  ', 'ctermbg=06 ctermfg=19'],
    \ '!':  [' Shell ', ''],
    \ 'r':  ['Prompt ', ''],
    \ }

func! UpdateStatusLineMode(mode) abort
    if a:mode == g:most_recent_mode
        return g:mode_settings[a:mode][0]
    endif

    let g:most_recent_mode = a:mode

    exec 'highlight SLMode cterm=bold ' . g:mode_settings[a:mode][1]

    return g:mode_settings[a:mode][0]
endfunc

" set statusline=%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P
set statusline=
set statusline+=%#SLMode#\ %{UpdateStatusLineMode(mode())}\ %*\ %y%r
set statusline+=\ %=
set statusline+=%3*%<%f%*%1*%{&mod?'\ [+]':''}%*
set statusline+=\ %=
set statusline+=%2*%-7.(U+%B%)%*\ %-12.(%l,%c%V%)\ %P

let g:inactive_statusline="          %y%r %=%<%f%{&mod?'\ [+]':''} %=%-7.(U+%B%) %-12.(%l,%c%V%) %P"

augroup vimrc
    autocmd WinLeave * let &l:stl = g:inactive_statusline
    autocmd WinEnter * set stl<
augroup end
