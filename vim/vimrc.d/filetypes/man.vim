" Load the :Man command
if !has('nvim')
    Plug 'vim-utils/vim-man'
endif

let g:ft_man_folding_enable = 1 " Fold manpages with foldmethod=indent foldnestmax=1.
