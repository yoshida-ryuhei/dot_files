set encoding=utf-8

if &shell =~# 'fish$'
	set shell=bash
endif

set hlsearch

set runtimepath+=~/dot_files/vim
runtime! config/*.vim

" 対応する括弧やブレースを表示
set showmatch matchtime=1

"コードの色分け
syntax on
filetype plugin indent on

"自動改行
set display=lastline

"下のメニュー表示と表示内容
set laststatus=2
