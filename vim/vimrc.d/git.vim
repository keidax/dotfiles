" Git-related plugins and settings

" Syntax for .gitignore files
Plug 'gisphm/vim-gitignore'

" Vim interface for Git operations
Plug 'tpope/vim-fugitive'

" Show diff status in sign column
Plug 'airblade/vim-gitgutter'

" GitGutter settings
let g:gitgutter_sign_removed = '▁▁'
let g:gitgutter_sign_removed_first_line = '▔▔'
let g:gitgutter_sign_added = '++'
let g:gitgutter_sign_modified = '~~'
let g:gitgutter_sign_modified_removed = '≃≃'

" Better conflict resolution
Plug 'whiteinge/diffconflicts'
