"viとの互換性を無効にする(INSERT中にカーソルキーが有効になる)
set nocompatible
"カーソルを行頭，行末で止まらないようにする
set whichwrap=b,s,h,l,<,>,[,]

"BSで削除できるものを指定する
set backspace=indent,eol,start


set title			"タイトル表示
set autoindent
set tabstop=4
set ignorecase
set smartcase
set background=dark	"暗くする
set number			"行番号をふる
set smartindent		"自動インデント
set completeopt=menuone
set shiftwidth=4
filetype detect
"自動的にIMEをオフにする
set iminsert=0
set imsearch=-1

"カーソル移動
source $VIMRUNTIME/macros/matchit.vim " Vimの「%」を拡張す

" 対応する括弧やブレースを表示
set showmatch matchtime=1

"コードの色分け
syntax on
filetype indent on
set hlsearch

" 現在の行に、下線を表示する
set cursorline

" delete last space before saving file https://vim.fandom.com/wiki/Remove_unwanted_spaces
augroup vim_del_end_space
	autocmd!
	autocmd BufWritePre * %s/\s\+$//e
augroup END

"最後のカーソル位置を復元する
augroup vimrcEx
	autocmd!
	autocmd BufRead * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g`\"" | endif
augroup END

augroup auto_defx
	autocmd!
	autocmd StdinReadPre * let s:std_in=1
	autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | Defx -split=vertical | endif
augroup END
