" vim/delete_unwanted_space.vim
" This file is used to delete unwanted space automatically, which is at the end of line.
augroup delete_unwanted_space
	autocmd!
	autocmd BufWrite,FileWritePre,FileAppendPre * :%s/\s\+$//e
augroup END
