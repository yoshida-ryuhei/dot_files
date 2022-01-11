let s:status = "NY"
" WJ, AC, NY, WA
let s:word_num ="0"

augroup vimproc-async-receive-test
augroup END

" this comman is done just before saving files
" TODO please repair this
augroup myconfig-tex-count-words
	autocmd!
	autocmd BufReadPost,BufNewFile,FileReadPost,FilterReadPost,StdinReadPost,BufWrite,FileWritePost,FileAppendPost *.tex call s:count_words()
augroup END

function! s:count_words()
	let l:tmp = system("texcount ".expand("%")." -inc -1 2>/dev/null")
	let l:word_num = split(l:tmp,"+")[0]
	let s:word_num = l:word_num
	return l:word_num
endfunction
function! s:return_counted_words()
	return s:word_num
endfunction

function! s:check_tex(status)
	if a:status == 0
		highlight ErrorLine None
		let sub = vimproc#system("cat build/".expand("%:r").".log | grep -ev Proceeding | grep -e !")
		if sub == ""
			let s:status = "AC"
			let s:win_name="latexmk_log"
			let s:latexmk_bufnr=bufwinnr('^'.s:win_name.'$')
			if s:latexmk_bufnr > 0
				execute s:latexmk_bufnr." wincmd w"
				norm! gg
				norm! dG
				wincmd p
			endif
			return
		endif
	endif
	let file =vimproc#fopen("build/".expand("%:r").".log")
	let res = file.read()

	let s:status = "WA"

	let s:error_line_num=matchstr(res, '\(l.\)\@<=\d\+')
	echo s:error_line_num." has error!"
	highlight ErrorLine ctermfg=red ctermbg=blue cterm=underline guifg=#ffff60 gui=underline
	execute "match ErrorLine /\\%".s:error_line_num."l/"

	let s:win_name="latexmk_log"
	let s:latexmk_bufnr=bufwinnr('^'.s:win_name.'$')
	if s:latexmk_bufnr > 0
		execute s:latexmk_bufnr." wincmd w"
	else
		execute "new ".s:win_name
		setlocal nobuflisted
		setlocal noswapfile
		setlocal buftype=nofile
		setlocal bufhidden=delete
		setlocal foldcolumn=0
		setlocal nobuflisted
		setlocal nospell
		setlocal nowrap

		setlocal filetype=latexmk_log
	endif

	silent call append(0,split(res,'\r\n\|\r\|\n'))

	syntax keyword latexmkError undefined
	syntax match latexmkError "! \S*"
	syntax match  latexmkLineNum "l.\d\+"
	syntax match  latexmkLineNumOther "\(l.\d\+\)\@<=\s\S*"

	highlight LineNum ctermfg=red ctermbg=blue cterm=none guifg=#ffff60 gui=none
	highlight LineNumOther cterm=underline gui=underline

	highlight link latexmkError Error
	highlight link latexmkLineNumOther LineNumOther
	highlight link latexmkLineNum LineNum
	norm! gg
	call search("!")
	norm! zt
	wincmd p
endfunction

set updatetime=100


" コマンド終了時に呼ばれる関数
function! s:finish(result,status)
	echom "finish latexmk"
	call s:check_tex(a:status)
	augroup vimproc-async-receive-test
		autocmd!
	augroup END
endfunction

function! s:receive_vimproc_result()
	if !has_key(s:, "vimproc")
		return
	endif

	let vimproc = s:vimproc

	try
		if !vimproc.stdout.eof
			let s:result["stdout"] .= vimproc.stdout.read()
		endif

		if !vimproc.stderr.eof
			let s:result["stderr"] .= vimproc.stderr.read()
		endif

		if !(vimproc.stdout.eof && vimproc.stderr.eof)
			return 0
		endif
	catch
		echom v:throwpoint
	endtry


	call vimproc.stdout.close()
	call vimproc.stderr.close()
	let [cond, status] = vimproc.waitpid()
	" 終了時に呼ぶ
	echomsg cond
	echomsg status
	call s:finish(s:result,status)
	unlet cond
	unlet status
	unlet s:vimproc
	unlet s:result
endfunction

function! g:Myconfig_tex_build()
	call s:system_async("latexmk ".expand("%"))
endfunction

function! s:tex_build_status()
	return s:status
endfunction

function! g:Myconfig_tex_status()
	return s:tex_build_status()
endfunction

function! g:Myconfig_tex_count_words()
	return s:return_counted_words()
endfunction

function! s:system_async(cmd)
	let cmd = a:cmd
	let g:vimproc = vimproc#popen2(cmd)
	call g:vimproc.stdin.close()
	let s:status = "WJ"

	let s:vimproc = g:vimproc
	let s:result = {"stdout":"","stderr":""}

	augroup vimproc-async-receive-test
		execute "autocmd! CursorHold,CursorHoldI * call"
					\               "s:receive_vimproc_result()"
	augroup END
endfunction


function! g:Open_pdf()
	let s:tex_path =  expand("%:p:r")
	echomsg "tex_path is ".s:tex_path
	let path_list = split(s:tex_path,'/')
	call insert(path_list,'build',-1)
	call insert(path_list,'',0)
	echomsg path_list
	let s:pdf_path = join(path_list,'/').'.pdf'
	echomsg "pdf_path is ".s:pdf_path
	if ! filereadable(s:pdf_path)
		echohl ErrorMsg | echo 'pdf_path : '.s:pdf_path.' is invalid.' | echohl None
	else
		if has("mac")
			" mac用の設定
			let l:open_command = 'open'
		elseif has("unix")
			" unix固有の設定
			let l:open_command = 'xdg-open'
		else
			echomsg 'unknown OS'
			throw 'unknown OS'
		endif

		let sub = vimproc#popen2(l:open_command.' '.s:pdf_path)
		let res = ''
		while !sub.stdout.eof
			let res .= sub.stdout.read()
		endwhile
	endif
endfunction

augroup auto_compile_tex
	autocmd!
	autocmd BufWrite,FileWritePost,FileAppendPost *.tex call g:Myconfig_tex_build()
augroup END

" auto format tool for latexindent
function! s:latexindent()
	let now_line = line(".")
	exec ":%! latexindent --modifylinebreaks --local --logfile=/dev/null"
	exec ":" . now_line
endfunction

function! LaTexIndent()
	call s:latexindent()
endfunction

nnoremap <silent><F3> :<C-u>call LaTexIndent()<CR>

let g:tex_conceal=''
nnoremap <silent> <Space>t :call g:Myconfig_tex_build()<CR>
nnoremap <silent> <Space>o :silent call g:Open_pdf()<CR>
