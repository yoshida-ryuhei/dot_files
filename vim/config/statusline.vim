function! s:count_words()
	if &filetype == "tex" || &filetype == "plaintex"
		return "[".g:Myconfig_tex_count_words()." words]"
	endif
	return ""
endfunction

function! s:tex_status()
	if &filetype == "tex" || &filetype == "plaintex"
		return "[".g:Myconfig_tex_status()."] "
	else
		return ""
	endif
endfunction
function! s:cp_helper_status()
	if exists('g:loaded_cp_helper')
		return cp_helper#statusline()
	endif
	return ""
endfunction

function! SetStatusLine()
	if mode() =~ 'i'
		let c = 1
		let mode_name = 'Insert'
	elseif mode() =~ 'n'
		let c = 2
		let mode_name = 'Normal'
	elseif mode() =~ 'R'
		let c = 3
		let mode_name = 'Replace'
	else
		let c = 4
		let mode_name = 'Visual'
	endif

	let l:cp_helper_str = s:cp_helper_status()
	let l:counted_words = s:count_words()
	let l:tex_status = s:tex_status()
	return '%' . c . '*[' . mode_name . ']%* %<%F%=%m%r '.l:counted_words.l:tex_status.l:cp_helper_str.' %18([%{toupper(&ft)}][%l/%L]%)%*'
endfunction

hi User1 cterm=bold ctermbg=red ctermfg=white ctermbg=red ctermfg=white
hi User2 cterm=bold ctermbg=green ctermfg=white
hi User3 cterm=bold ctermbg=yellow ctermfg=white
hi User4 cterm=bold ctermbg=blue ctermfg=black

set statusline=%!SetStatusLine()
