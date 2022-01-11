"python3
set pyxversion=3
set pyx=3

"python
if &filetype=="python"
	setlocal tabstop=4
	setlocal shiftwidth=4
endif
setlocal expandtab


" copy from https://raw.githubusercontent.com/google/yapf/main/plugins/vim/autoload/yapf.vim
function! s:yapf() range
  " Determine range to format.
  let l:line_ranges = a:firstline . '-' . a:lastline
  let l:cmd = 'yapf --lines=' . l:line_ranges

  " Call YAPF with the current buffer
  if exists('*systemlist')
    let l:formatted_text = systemlist(l:cmd, join(getline(1, '$'), "\n") . "\n")
  else
    let l:formatted_text =
        \ split(system(l:cmd, join(getline(1, '$'), "\n") . "\n"), "\n")
  endif

  if v:shell_error
    echohl ErrorMsg
    echomsg printf('"%s" returned error: %s', l:cmd, l:formatted_text[-1])
    echohl None
    return
  endif

  " Update the buffer.
  execute '1,' . string(line('$')) . 'delete'
  call setline(1, l:formatted_text)

  " Reset cursor to first line of the formatted range.
  call cursor(a:firstline, 1)
endfunction

function! Yapf()
	call s:yapf()
endfunction

if executable('yapf')
	augroup python_yapf
		autocmd!
		"autocmd BufWrite,FileWritePre,FileAppendPre *.py call s:yapf()
	augroup END
endif

nnoremap <silent><F3> :<C-u>call Yapf()<CR>
