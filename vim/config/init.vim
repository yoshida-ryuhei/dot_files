" disable compability to vi (enable cursor when insert mode)
set nocompatible
"カーソルを行頭，行末で止まらないようにする
set whichwrap=b,s,h,l,<,>,[,]

" extend backspace so that the indent, eol (End of Line) and start.
set backspace=indent,eol,start


set title			"タイトル表示
set autoindent
set tabstop=4
set ignorecase
set background=dark	"暗くする
set number			"行番号をふる
" auto indent
set smartindent
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

" 現在の行に、下線を表示する
set cursorline

set list
set listchars=tab:▸-
noremap <F5> :set list!<CR>
inoremap <F5> <C-o>:set list!<CR>
cnoremap <F5> <C-c>:set list!<CR>

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

" configureation for python3
if has("mac")
	let s:python_path = '/opt/homebrew/opt/python@3.10/bin/python3'
elseif has("unix")
	let s:python_path = '/usr/bin/python3'
else
	echomsg 'unknown OS'
	throw 'unknown OS'
endif

let g:python3_host_prog=s:python_path
"set pythonthreehome=s:python_path
"echomsg s:python_path.' will be added to sys.path'
let s:python_lib_path = system(s:python_path.' -c "import sys;print(sys.path[-1])"')
"echomsg s:python_lib_path.' will be added to sys.path'
py3 <<EOM
import sys
import vim

python_lib_path = vim.eval('s:python_lib_path').strip()
if not python_lib_path in sys.path:
	sys.path.insert(0, python_lib_path)
EOM
