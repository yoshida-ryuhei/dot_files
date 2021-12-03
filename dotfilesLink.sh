#!/bin/bash
mkdir -p ~/.config
ln -sf ~/dot_files/fish ~/.config/

mkdir -p ~/.config/git
ln -sf ~/dot_files/git_files/config ~/.config/git/config
ln -sf ~/dot_files/git_files/attributes ~/.config/git/attributes
ln -sf ~/dot_files/git_files/gitignore_global ~/.config/git/gitignore_global


ln -sf ~/dot_files/vim/.vimrc ~/.vimrc
mkdir -p ~/.config/vim/rc
ln -sf ~/dot_files/vim/dein.toml ~/.config/vim/rc/dein.toml
ln -sf ~/dot_files/vim/dein_lazy.toml ~/.config/vim/rc/dein_lazy.toml
ln -sf ~/dot_files/vim/snippets ~/.config/vim/rc/
