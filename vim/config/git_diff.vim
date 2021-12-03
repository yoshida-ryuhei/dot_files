function! s:diff_pop()
	let l:diff = system("git diff ".expand("%"))
	if empty(l:diff)
		return
	end
	let diffs = split(diff,'\n')
	call popup_atcursor(diffs, #{ border: []})
endfunction

command! Termdiff call s:diff_pop()
