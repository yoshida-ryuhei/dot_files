" lang/cpp.vim

" auto format tool clang-format
function! s:clang_format()
	let now_line = line(".")
	exec ":%! clang-format"
	exec ":" . now_line
endfunction

if executable('clang-format')
	augroup cpp_clang_format
		autocmd!
		autocmd BufWrite,FileWritePre,FileAppendPre *.[chi]pp call s:clang_format()
		autocmd BufWrite,FileWritePre,FileAppendPre *.[ch] call s:clang_format()
	augroup END
endif

function! g:Move_cpp(command)
	if expand('%:e') ==? "cpp" && filereadable(expand("%:r").".hpp")
		let s:new_file = expand("%:r").".hpp"
	elseif expand('%:e') ==? "hpp" &&  filereadable(expand("%:r").".cpp")
		let s:new_file = expand("%:r").".cpp"
	else
		let s:new_file = expand("%:p")
	endif
	execute a:command." ".s:new_file
endfunction

nnoremap <silent>sv :<C-u>call g:Move_cpp("vsplit")<CR>
nnoremap <silent>ss :<C-u>call g:Move_cpp("split")<CR>

