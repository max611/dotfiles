#!/bin/bash

set -e
export LC_ALL="en_US.UTF-8"

if [ ! -d ~/.oh-my-zsh ]; then
    git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
fi

if [ ! -d ~/.fzf ]; then
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install
fi

for f in `ls . `
do
    if [[ $f == "install.sh" ]] ; then
        continue
    fi

    ln -fs ~/dotfiles/$f ~/.${f}
done

if [ ! -d ~/fonts ]; then
    git clone https://github.com/powerline/fonts.git ~/fonts
    ~/fonts/install.sh
fi

ln -fs ~/dotfiles/blinks.zsh-theme ~/.oh-my-zsh/custom/themes/
vim -E -u NONE -S ~/.vimrc +PluginInstall +qall
