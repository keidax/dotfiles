" Clean up by hiding the statusline & mode
set noshowmode laststatus=0
" Restore when done with FZF
autocmd vimrc BufLeave <buffer> set showmode laststatus=2

" The default FZF layout doesn't seem to account for a hidden statusline, so
" we can shrink the FZF window by 1 line to remove that dead space.
resize -1
