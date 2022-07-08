augroup filetypedetect
    " Tree-sitter corpus files are in the corpus/ or test/corpus/ directories.
    au BufNewFile,BufReadPost *.txt 
        \ if expand("<afile>:p:h:t") ==# "corpus" && (
        \   expand("<afile>:p:h:h:t") ==# "test" ||
        \   expand("<afile>:p:h:h:t") =~# "tree-sitter-*" )
        \| setf ts_corpus
        \| endif
augroup END
