" Updated Ruby support files
Plug 'vim-ruby/vim-ruby'

" Include projectionist support for common Ruby project layouts
Plug 'tpope/vim-rake'

" Projectionist support for Gemfiles
let g:projectionist_heuristics["Gemfile"] = {
    \ "Gemfile": { "alternate": "Gemfile.lock" },
    \ "Gemfile.lock": { "alternate": "Gemfile" },
    \ }

" Highlighting for YARD params
Plug 'noprompt/vim-yardoc'

Plug 'rhysd/vim-textobj-ruby'
let g:textobj_ruby_more_mappings = 1

" Ruby syntax settings
let g:ruby_indent_assignment_style = 'variable'
let g:ruby_indent_block_style = 'do'
let g:ruby_minlines = 100
let g:ruby_operators = 1

" For custom snippets
let g:ruby_double_quote = 1
