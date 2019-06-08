" Python syntax settings
" Turn on all highlighting
let g:python_highlight_all = 1

" Improved folding
Plug 'tmhedberg/SimpylFold'

" Proper indenting of closing braces
Plug 'Vimjas/vim-python-pep8-indent'

" Set for faster startup
let g:python_host_prog = exepath('python2')
let g:python3_host_prog = exepath('python3')
