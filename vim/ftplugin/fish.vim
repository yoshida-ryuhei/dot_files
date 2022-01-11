" lang/fish.vim

" auto format tool for fish_indent
function! s:fish_indent()
	let now_line = line(".")
	exec ":%! fish_indent"
	exec ":" . now_line
endfunction

if executable('fish_indent')
	augroup fish_fish_indent
		autocmd!
		autocmd BufWrite,FileWritePre,FileAppendPre *.fish call s:fish_indent()
	augroup END
endif

function! Fish_indent()
	call s:fish_indent()
endfunction

nnoremap <silent><F3> :<C-u>call Fish_indent()<CR>
