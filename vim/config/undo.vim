if has('persistent_undo')
	let vim_undo_dir = expand("~/.config/vim/undo")

	if ! isdirectory(vim_undo_dir)
		call mkdir(vim_undo_dir)
	endif

	if ! isdirectory(vim_undo_dir)
		echo vim_undo_dir." is not made!"
		throw "ERROR".vim_undo_dir." is not made!"
	endif

	set undodir=~/.config/vim/undo
	set undofile

endif
