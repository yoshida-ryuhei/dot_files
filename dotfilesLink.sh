#!/bin/bash

# symbolic files under expand("~")
ln -sf ~/dot_files/tmux/.tmux.conf ~/.tmux.conf
ln -sf ~/dot_files/git_files/.gitconfig ~/.gitconfig
ln -sf ~/dot_files/git_files/.gitattributes ~/.gitattributes
ln -sf ~/dot_files/git_files/.gitignore_global ~/.gitignore_global

mkdir -p ~/.config
ln -sf ~/dot_files/fish ~/.config/
ln -sf ~/dot_files/python/yapf ~/.config

ln -sf ~/dot_files/vim/.vimrc ~/.vimrc
mkdir -p ~/.config/vim/rc
ln -sf ~/dot_files/vim/dein.toml ~/.config/vim/rc/dein.toml
ln -sf ~/dot_files/vim/dein_lazy.toml ~/.config/vim/rc/dein_lazy.toml
ln -sf ~/dot_files/vim/dein_lazy_ddc.toml ~/.config/vim/rc/dein_lazy_ddc.toml
ln -sf ~/dot_files/vim/snippets ~/.config/vim/rc/


ln -sf ~/dot_files/.latexmkrc ~/.latexmkrc

if [ "$(uname)" = 'Darwin' ]; then
	echo "mac"
	## alias for man julia
	ln -sf /Applications/Julia-*.app/Contents/Resources/julia/share/man/man1/* /usr/local/share/man/man1/
	# see https://docs.docker.com/docker-for-mac/#fish-shell
	ln -sf /Applications/Docker.app/Contents/Resources/etc/docker.fish-completion ~/.config/fish/completions/docker.fish
	ln -sf /Applications/Docker.app/Contents/Resources/etc/docker-compose.fish-completion ~/.config/fish/completions/docker-compose.fish

	## option to clangd
	mkdir -p ~/Library/Preferences/clangd
	ln -sf ~/dot_files/clangd/config.yaml ~/Library/Preferences/clangd/config.yaml
elif [ "$(expr substr $(uname -s) 1 5)" = 'Linux' ]; then
	echo "Linux"

	## option to clangd
	mkdir -p ~/.config/clangd
	ln -sf ~/dot_files/clangd/config.yaml ~/.config/clangd/config.yaml.
fi
