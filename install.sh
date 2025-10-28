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

    if [[ $f == "functions" ]]; then
        mkdir -p ~/.zsh
        cp -r ~/dotfiles/$f ~/.zsh/$f
    elif [ -d ~/dotfiles/$f ]; then
        cp -r ~/dotfiles/$f ~/.${f}
    else
        cp ~/dotfiles/$f ~/.${f}
    fi
done

if [ ! -d ~/fonts ]; then
    git clone https://github.com/powerline/fonts.git ~/fonts
    ~/fonts/install.sh
fi

if [ $SPIN ]; then
  sudo apt-get install -y git-absorb
fi

cp ~/.oh-my-zsh/themes/powerlevel10k/powerlevel10k.zsh-theme ~/powerlevel10k/

