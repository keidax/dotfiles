let b:ycm_cmd = './install.py'
let b:ycm_cmd .= ' --clang-completer'
if executable('rustc')
    let b:ycm_cmd .= ' --racer-completer'
endif
" In neovim, we can run the YCM install script in a :term window, so it doesn't
" block the whole editor.
if has('nvim')
    let b:ycm_cmd = ":new | call termopen('" . b:ycm_cmd . "')"
endif

" Heavyweight completion engine
Plug 'Valloric/YouCompleteMe', { 'do': b:ycm_cmd }
