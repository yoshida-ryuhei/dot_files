set -x LANG en_UK.utf-8
set -x LC_ALL en_US.UTF-8

if not status --is-interactive
	exit
end

#.fishのlistの読み込み
if test -e ~/dot_files/fish/source.fish
	source ~/dot_files/fish/source.fish
end
