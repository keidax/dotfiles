scriptencoding utf-8

function! s:get_test_list(orig_buf_id) abort
    return getbufvar(a:orig_buf_id, 'vim_test_finished_buffer_ids', [])
endfunction

function! s:set_test_list(orig_buf_id, list) abort
    return setbufvar(a:orig_buf_id, 'vim_test_finished_buffer_ids', a:list)
endfunction

function! s:get_running_jobs(orig_buf_id) abort
    return getbufvar(a:orig_buf_id, 'vim_test_running_job_ids', [])
endfunction

function! s:set_set_running_jobs(orig_buf_id, list) abort
    return setbufvar(a:orig_buf_id, 'vim_test_running_job_ids', a:list)
endfunction

function! s:add_to_test_list(orig_buf_id, buf_id) abort
    let l:list = s:get_test_list(a:orig_buf_id)
    call add(l:list, a:buf_id)
    call s:set_test_list(a:orig_buf_id, l:list)
endfunction

function! s:delete_buffer(buf_id) abort
    " Don't delete the active buffer
    " This lets us preserve a successful test run by keeping it focused.
    if a:buf_id == bufnr('%')
        return
    endif

    execute 'silent bd! ' . a:buf_id
endfunction

" Callback for job command
function! s:term_exit(job_id, exit_code, event) dict abort
    if a:exit_code == 0
        call s:delete_buffer(self.buf_id)
        echom 'Success! ✅'
    else
        call s:add_to_test_list(self.orig_buf_id, self.buf_id)
        echom 'Failure! ❌'
    endif
endfunction

" Clean up remaining failure windows
function! s:clean_up_failures(buf_id) abort
    let l:list = s:get_test_list(a:buf_id)
    if empty(l:list)
        return
    endif

    for old_buf_id in l:list
        if bufexists(old_buf_id)
            call s:delete_buffer(old_buf_id)
        endif
    endfor

    call remove(l:list, 0, -1)
endfunction

function! test#strategy#neovim_custom(cmd) abort
    let l:orig_buf_id = bufnr('%')
    call s:clean_up_failures(l:orig_buf_id)

    let term_position = get(g:, 'test#neovim#term_position', 'botright')
    execute term_position . ' new'
    let opts = {
        \ 'buf_id': bufnr('%'),
        \ 'orig_buf_id': l:orig_buf_id,
        \ 'on_exit': function('s:term_exit')
        \ }
    call termopen(a:cmd, opts)
    normal! G
    wincmd p
endfunction
