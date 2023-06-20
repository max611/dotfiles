#!/bin/bash

set -e
export LC_ALL="en_US.UTF-8"

if [ ! -d ~/.oh-my-zsh ]; then
    git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
fi

if [ ! -d ~/.zsh/zsh-autosuggestions ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
fi

if [ ! -d ~/.fzf ]; then
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install
fi

if [ ! -d ~/.oh-my-zsh/themes/powerlevel10k ]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/themes/powerlevel10k
    mkdir ~/powerlevel10k
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

cp -R ~/dotfiles/.p10k.zsh ~/.p10k.zsh
ln -fs ~/.oh-my-zsh/themes/powerlevel10k/powerlevel10k.zsh-theme ~/powerlevel10k/

