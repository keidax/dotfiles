" Dark powered neo-completion
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

let g:deoplete#enable_at_startup = 1
" Refresh completion candidates automatically
let g:deoplete#enable_refresh_always = 1

" Vim completion
Plug 'Shougo/neco-vim'

" Language syntax completion
Plug 'Shougo/neco-syntax'
let g:necosyntax#min_keyword_length = 2

" Tmux pane content completion
Plug 'wellle/tmux-complete.vim'
" Trigger not needed for deoplete
let g:tmuxcomplete#trigger = ''

" try out some ruby completions
" Plug 'fishbullet/deoplete-ruby'
" Plug 'Shougo/deoplete-rct'
Plug 'uplus/deoplete-solargraph'

" JS completion based on Tern engine
Plug 'carlitux/deoplete-ternjs'
" Include completion types
let g:deoplete#sources#ternjs#types = 1
" Include doc strings
let g:deoplete#sources#ternjs#docs = 1
" Include JS keywords
let g:deoplete#sources#ternjs#include_keywords = 1
