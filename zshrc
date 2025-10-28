# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
# if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#   source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
# fi
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
# source ~/powerlevel10k/powerlevel10k.zsh-theme

# ZSH_THEME="robbyrussell"
ZSH=$HOME/.oh-my-zsh

export LC_ALL="en_US.UTF-8"
export GOPATH=$HOME
export GPG_TTY=$(tty)
export EDITOR="vim"
export VISUAL="vim"

POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true
# ZSH_THEME="powerlevel10k/powerlevel10k"
alias tmux="TERM=screen-256color-bce tmux"
alias k="kubectl"
alias gtsendit="gt modify --all && gt submit"
alias gthelp='~/scripts/gthelp.sh'

bindkey '^[f' forward-word
bindkey '^[b' backward-word

export FZF_DEFAULT_COMMAND="rg --files --no-ignore-vcs --hidden"

plugins=(
	git
)

source $ZSH/oh-my-zsh.sh
unsetopt correct_all

[ -f /opt/dev/dev.sh ] && source /opt/dev/dev.sh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

if type nvim > /dev/null 2>&1; then
  alias vim='nvim -u ~/.vimrc'
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
# [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

[[ -x /opt/homebrew/bin/brew ]] && eval $(/opt/homebrew/bin/brew shellenv)

[[ -f /opt/dev/sh/chruby/chruby.sh ]] && { type chruby >/dev/null 2>&1 || chruby () { source /opt/dev/sh/chruby/chruby.sh; chruby "$@"; } }

# Shopify Hydrogen alias to local projects
alias h2='$(npm prefix -s)/node_modules/.bin/shopify hydrogen'

# is-it-shipped
functionsfpath=(~/.zsh/functions $fpath)
autoload -Uz ~/.zsh/functions/[^_]*

# cloudplatform: add Shopify clusters to your local kubernetes config
export KUBECONFIG=${KUBECONFIG:+$KUBECONFIG:}/Users/maxstonge/.kube/config:/Users/maxstonge/.kube/config.shopify.cloudplatform

source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"

# Function to warn when running git commands in branches with 'mso' prefix
git() {
  local current_branch
  current_branch=$(command git symbolic-ref --short HEAD 2>/dev/null)

  # List of ignored commands (no warning will be shown)
  local ignored_commands=("checkout" "status" "log" "diff")

  # Check if the current command is in the ignored list
  local should_ignore=false
  for cmd in "${ignored_commands[@]}"; do
    if [[ "$1" == "$cmd" ]]; then
      should_ignore=true
      break
    fi
  done

  if [[ -n "$current_branch" && "$current_branch" == mso* && "$should_ignore" == false ]]; then
    echo "⚠️  WARNING: You are on branch '$current_branch' which has the 'mso' prefix."
    echo "Do you want to continue with 'git $@'? (y/n)"
    read -r response
    if [[ ! $response =~ ^[Yy]$ ]]; then
      echo "Operation cancelled."
      return 1
    fi
  fi

  command git "$@"
}

secrets () {
  EJSON="$HOME/.secrets/${1:-secrets}.ejson"
  eval $(ejson2env "$EJSON")
}

# Function to generate PR description using Claude
describepr() {
  local description=$(claude -p "Generate a Pull Request description in markdown format for the changes in this branch compared to main. Structure it as follows:

## Why
* Explain the problem being solved and why it's important to address it
* Highlight any user impact or business value

## How
* Describe the key technical changes made to solve the problem
* Explain the approach taken and why this approach was chosen

## Testing
* Provide clear testing instructions
* Note any edge cases that should be verified

Based on the git diff, create this description with a focus on explaining WHY this change matters and HOW the implementation solves the problem effectively.

IMPORTANT: Start your response directly with the markdown content (## Why) with no introductory text like 'Here's a PR description' or similar phrases. I want only the description itself.")

  # Remove any potential introductory text using a more compatible approach
  # This extracts everything from the first ## to the end of the text
  description=$(echo "$description" | awk '/^## Why/,0')

  if [[ "$1" == "update" ]]; then
    echo "$description" | gh pr edit --body-file -
    echo "PR description updated successfully."
  else
    echo "$description"
    echo ""
    echo "To update the PR with this description, run 'describepr update'"
  fi
}

# Function to create a new worktree, implement a feature, and push it using Claude
dev-feature() {
  if [ -z "$1" ]; then
    echo "Error: Feature description is required"
    echo "Usage: dev-feature \"Description of the feature to implement\""
    return 1
  fi

  # Get current repository information
  local repo_name=$(basename -s .git $(git config --get remote.origin.url))
  local current_dir=$(pwd)
  local main_branch=$(git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@')

  # Create the prompt for Claude
  local prompt="# Create a New Worktree and Implement Feature

## Repository Information
- Repository: $repo_name
- Current working directory: $current_dir
- Main/default branch: $main_branch

## Feature Request
$1

## Instructions
Please:

1. Create a new worktree with an appropriately named feature branch
2. Implement the requested feature in the new worktree
3. Commit your changes with clear commit messages
4. Prompt me to push the branch to the remote repository with a detailed PR description using markdown.
5. You have the permissions for the Edit and Bash tools.

In your response, explain:
- The files you modified or created
- The implementation approach you took
- Any considerations or trade-offs in your solution"

  # Run Claude CLI with the prompt
  echo "Creating feature branch and implementing: $1"
  echo "Using Claude to implement the feature..."
  claude -p  --allowedTools "Bash(git:*),Edit" "$prompt"
}

# Added by tec agent
[[ -x /Users/maxstonge/.local/state/tec/profiles/base/current/global/init ]] && eval "$(/Users/maxstonge/.local/state/tec/profiles/base/current/global/init zsh)"
