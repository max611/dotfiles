ZSH=$HOME/.oh-my-zsh

export LC_ALL="en_US.UTF-8"
export GOPATH=$HOME

ZSH_THEME="blinks"
alias tmux="TERM=screen-256color-bce tmux"
alias k="kubectl"

bindkey '^[[1;9C' forward-word
bindkey '^[[1;9D' backward-word
bindkey -s '^P' 'vim $(fzf)\n'

export FZF_DEFAULT_COMMAND="rg --files --no-ignore-vcs --hidden"

alias be="bundle exec"
alias test="ruby -I test"
alias shopify-dev='/Users/haeky/src/github.com/Shopify/shopify-cli-internal/bin/shopify'

plugins=(git)

source $ZSH/oh-my-zsh.sh
unsetopt correct_all

[ -f /opt/dev/dev.sh ] && source /opt/dev/dev.sh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

if type nvim > /dev/null 2>&1; then
  alias vim='nvim -u ~/.vimrc'
fi

# fco - checkout git branch/tag
fco() {
  local tags branches target
  branches=$(
    git --no-pager branch --all \
      --format="%(if)%(HEAD)%(then)%(else)%(if:equals=HEAD)%(refname:strip=3)%(then)%(else)%1B[0;34;1mbranch%09%1B[m%(refname:short)%(end)%(end)" \
    | sed '/^$/d') || return
  tags=$(
    git --no-pager tag | awk '{print "\x1b[35;1mtag\x1b[m\t" $1}') || return
  target=$(
    (echo "$branches"; echo "$tags") |
    fzf --no-hscroll --no-multi -n 2 \
        --ansi) || return
  git checkout $(awk '{print $2}' <<<"$target" )
}


# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/haeky/google-cloud-sdk/path.zsh.inc' ]; then source '/Users/haeky/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/haeky/google-cloud-sdk/completion.zsh.inc' ]; then source '/Users/haeky/google-cloud-sdk/completion.zsh.inc'; fi

# cloudplatform: add Shopify clusters to your local kubernetes config
export KUBECONFIG=${KUBECONFIG:+$KUBECONFIG:}$HOME/.kube/config:$HOME/.kube/config.shopify.cloudplatform
if [ -e /Users/haeky/.nix-profile/etc/profile.d/nix.sh ]; then . /Users/haeky/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
