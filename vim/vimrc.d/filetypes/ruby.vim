" Updated Ruby support files
Plug 'vim-ruby/vim-ruby'
" Extra tools for Ruby on Rails
Plug 'tpope/vim-rails'

" Ruby syntax settings
let g:ruby_fold = 1
let g:ruby_foldable_groups = 'ALL'
let g:ruby_indent_assignment_style = 'variable'
let g:ruby_indent_block_style = 'do'
let g:ruby_minlines = 100
let g:ruby_operators = 1

" For custom snippets
let g:ruby_double_quote = 1

" Speed up provider (using global ruby)
let g:ruby_host_prog = 'RBENV_VERSION="$(rbenv global)" neovim-ruby-host'
