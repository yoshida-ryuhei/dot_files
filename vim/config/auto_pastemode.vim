" vim/config/auto_pastemode.vim
if !has("patch-8.0.0238")
	echohl WarningMsg | echo "This version is too old to move auto paste." | echohl None
endif

" see https://ttssh2.osdn.jp/manual/4/ja/usage/tips/vim.html
" if something is changed, see vim doc at https://github.com/vim/vim/blob/master/runtime/doc/term.txt
" Bracketed Paste Mode対応バージョン(8.0.0238以降)では、特に設定しない
" 場合はTERMがxtermの時のみBracketed Paste Modeが使われる。
" tmux利用時はTERMがscreenなので、Bracketed Paste Modeを利用するには
" 以下の設定が必要となる。
if &term =~ "screen"
	let &t_BE = "\e[?2004h"
	let &t_BD = "\e[?2004l"
	exec "set t_PS=\e[200~"
	exec "set t_PE=\e[201~"
endif
