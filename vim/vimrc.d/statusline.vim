
let g:most_recent_mode = ''
let g:mode_settings = {
    \ 'n':  ['Normal ', ['02', '04']],
    \ 'i':  ['Insert ', ['02', '0B']],
    \ 'v':  ['Visual ', ['02', '0D']],
    \ 'V':  ['V Line ', ['02', '0D']],
    \ "\<C-V>": ['V Block', ['02', '0D']],
    \ 's':  ['Select ', ['02', '09']],
    \ 'R':  ['Replace', ''],
    \ 'c':  ['Command', ['02', '0A']],
    \ 't':  [' Term  ', ['02', '0C']],
    \ '!':  [' Shell ', ''],
    \ 'r':  ['Prompt ', ''],
    \ }

func! UpdateStatusLineMode(mode) abort
    if a:mode == g:most_recent_mode
        return g:mode_settings[a:mode][0]
    endif

    let g:most_recent_mode = a:mode

    let l:fg = g:mode_settings[a:mode][1][0]
    let l:bg = g:mode_settings[a:mode][1][1]

    exec "call g:Base16hi('SLMode', g:base16_gui".l:fg.", g:base16_gui".l:bg.", g:base16_cterm".l:fg.", g:base16_cterm".l:bg.", 'bold')"

    return g:mode_settings[a:mode][0]
endfunc

" The mode is visible in statusline
set noshowmode

" set statusline=%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P
set statusline=
set statusline+=%#SLMode#\ %{UpdateStatusLineMode(mode())}\ %*\ %<%y%r
set statusline+=\ %=
set statusline+=%3*%f%*%1*%{&mod?'\ [+]':''}%*
set statusline+=\ %=
set statusline+=%(%l,%c%V%)\ \ %P

let g:inactive_statusline="          %<%y%r %=%f%{&mod?'\ [+]':''} %=%(%l,%c%V%)  %P"

augroup vimrc
    autocmd WinLeave * let &l:stl = g:inactive_statusline
    autocmd WinEnter * set stl<
augroup end
