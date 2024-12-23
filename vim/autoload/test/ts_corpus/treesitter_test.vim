let g:test#ts_corpus#treesitter_test#file_pattern = 'corpus\/.*\.txt$'

func! test#ts_corpus#treesitter_test#test_file(file) abort
    return a:file =~# g:test#ts_corpus#treesitter_test#file_pattern
endfunc

func! test#ts_corpus#treesitter_test#build_position(type, position) abort
    if a:type ==# 'nearest'
        return s:find_nearest(a:position)
    else
        return []
    endif
endfunc

func! test#ts_corpus#treesitter_test#build_args(args) abort
    return a:args
endfunc

func! test#ts_corpus#treesitter_test#executable() abort
    return 'tree-sitter test'
endfunc

func! s:find_nearest(position) abort
    let filename = a:position['file']
    let start_line = a:position['line']

    let lines = reverse(getbufline(filename, 1, start_line))

    let idx=0
    let found_idx=-1

    for line in lines
        if line =~# '\v^\=+$'
            let found_idx = idx
            break
        endif
        let idx += 1
    endfor

    if found_idx != -1
        return ['--include', shellescape('^' . lines[found_idx+1] . '$')]
    endif

    return []
endfunc
