" keymap.vim

" 分割
nnoremap ss :<C-u>split<CR>
nnoremap sv :<C-u>vsplit<CR>
nnoremap sj <C-w>j
nnoremap sk <C-w>k
nnoremap sl <C-w>l
nnoremap sh <C-w>h

" jjで<ESC>にする
inoremap <silent> jj <ESC>

" <Space>wで:wとか
nnoremap <silent> <Space>w :<C-u>w<CR>
nnoremap <silent> <Space>q :<C-u>q<CR>
nnoremap <silent> <Space>g :Termdiff<CR>
nnoremap <silent><C-n> :<C-u>Defx -split=vertical -toggle -winwidth=30<CR>
