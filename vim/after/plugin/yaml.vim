" Override vim-rails' filetype choice of 'eruby.yaml'. This file has to be in
" after/plugin so the autocmds are fired later than the ones in vim-rails.
au BufReadPost,BufNewFile *.yml,*.yml.example
    \ if &filetype == 'eruby.yaml' | set filetype=yaml | endif
