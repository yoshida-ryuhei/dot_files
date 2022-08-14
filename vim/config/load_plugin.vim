"deinの設定------------------------------------------------------------
" プラグインが実際にインストールされるディレクトリ
let s:dein_dir = expand('~/.config/vim/dein')
" dein.vim 本体
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

" if dein.vim does not exists, then clone from GitHub.com
if &runtimepath !~# '/dein.vim'
  if !isdirectory(s:dein_repo_dir)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
  endif
  execute 'set runtimepath^=' . fnamemodify(s:dein_repo_dir, ':p')
endif

if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)

  " TOML files to list up plugins
  let g:rc_dir    = expand('~/.config/vim/rc')
  let s:toml      = g:rc_dir . '/dein.toml'
  let s:lazy_toml = g:rc_dir . '/dein_lazy.toml'
  let s:ddc_toml = g:rc_dir . '/dein_ddc.toml'
  let s:ddu_toml = g:rc_dir . '/dein_ddu.toml'

  " load TOML files and cacheit
  call dein#load_toml(s:toml,      {'lazy': v:false})
  call dein#load_toml(s:lazy_toml, {'lazy': v:true})
  call dein#load_toml(s:ddc_toml, {'lazy': v:true})
  call dein#load_toml(s:ddu_toml, {'lazy': v:true})
  "finish settings
  call dein#end()
  call dein#save_state()
endif

" もし、未インストールものものがあったらインストール
if dein#check_install()
  call dein#install()
endif


