# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/powerlevel10k/powerlevel10k.zsh-theme

ZSH=$HOME/.oh-my-zsh

export LC_ALL="en_US.UTF-8"
export GOPATH=$HOME
export GPG_TTY=$(tty)

POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true
ZSH_THEME="powerlevel10k/powerlevel10k"
alias tmux="TERM=screen-256color-bce tmux"
alias k="kubectl"

bindkey '^[f' forward-word
bindkey '^[b' backward-word

export FZF_DEFAULT_COMMAND="rg --files --no-ignore-vcs --hidden"

plugins=(
	git
	zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh
unsetopt correct_all

[ -f /opt/dev/dev.sh ] && source /opt/dev/dev.sh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

if type nvim > /dev/null 2>&1; then
  alias vim='nvim -u ~/.vimrc'
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

[[ -x /opt/homebrew/bin/brew ]] && eval $(/opt/homebrew/bin/brew shellenv)
