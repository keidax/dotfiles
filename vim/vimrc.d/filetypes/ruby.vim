" Updated Ruby support files
Plug 'vim-ruby/vim-ruby'
" Extra tools for Ruby on Rails
Plug 'tpope/vim-rails'

" Highlighting for YARD params
Plug 'noprompt/vim-yardoc'

Plug 'rhysd/vim-textobj-ruby'
let g:textobj_ruby_more_mappings = 1

let g:fastfold_skip_filetypes = [ 'ruby' ]

" Ruby syntax settings
let g:ruby_indent_assignment_style = 'variable'
let g:ruby_indent_block_style = 'do'
let g:ruby_minlines = 100
let g:ruby_operators = 1

" For custom snippets
let g:ruby_double_quote = 1

" Use dockerized test script for appserver
" TODO: find a better way to do this?
if executable('script/test')
    let g:test#ruby#rspec#executable = 'script/test'
end
