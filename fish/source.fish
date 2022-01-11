set os_name (uname)

echo $os_name
if test $os_name = Darwin
    fish_add_path /usr/local/bin
    fish_add_path --append /usr/local/opt/openssl/bin
    fish_add_path --append /usr/local/texlive/2021basic/bin/universal-darwin/
    fish_add_path --append /usr/local/opt/openjdk/bin
    fish_add_path --append $HOME/.cargo/bin

    set -x MANPATH /usr/local/share/man $MANPATH
    set -x MANPATH /usr/share/man $MANPATH

    alias ls="ls -AFG"
    set not_os_name l

else if test $os_name = Linux
    fish_add_path /usr/local/texlive/2021/bin/x86_64-linux
    #set -x MANPATH /usr/local/texlive/2021/texmf-dist/doc/man $MANPATH
    #set -x INFOPATH /usr/local/texlive/2021/texmf-dist/doc/man $INFOPATH

    set -x CUDA_PATH /opt/cuda/
    fish_add_path $CUDA_PATH/bin
    set -x CPATH $CUDA_PATH/include $CPATH
    set -x LIBRARY_PATH $CUDA_PATH/lib64 $LIBRARY_PATH
    set -x LD_LIBRARY_PATH $CUDA_PATH/lib64 $LD_LIBRARY_PATH
    set -x DYLD_LIBRARY_PATH /usr/local/cuda-9.0/lib $DYLD_LIBRARY_PATH
    set -x CUDA_ROOT /usr/local/cuda-9.0
    set -x CPLUS_INCLUDE_PATH /opt/cuda/targets/x86_64-linux/include/cublas_v2.h $CPLUS_INCLUDE_PATH

    fish_add_path $HOME/.local/bin # for python binaries
    fish_add_path $HOME/.cargo/bin # for cargo
    fish_add_path $HOME/.poetry/bin # for poetry

    set -gx DOCKER_HOST "unix:///run/user/1000/docker.sock" # for rootless docker
    alias ls='ls -AFG --color=auto'
    set not_os_name m
    alias chrome='google-chrome &'
    alias start_gui="sudo systemctl start gdm"
else if test $os_name = Windows
    echo "Windows is invalid!"
    exit 1
else
    echo "unknown os!"
    exit 1
end

fish_add_path --append $HOME/dot_files/tools/bin
# echo "end of judging os "

source ~/dot_files/fish/alias.fish
