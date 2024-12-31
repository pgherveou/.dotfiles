# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
# [[ -f "$HOME/.p10k-instant-prompt.zsh" ]] && source "$HOME/.p10k-instant-prompt.zsh"
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


if [ -f "$HOME/.antigen.zsh" ]; then
  source $HOME/.antigen.zsh
  antigen use oh-my-zsh
  antigen theme romkatv/powerlevel10k
  antigen bundle git
  antigen bundle git-extras
  antigen bundle common-aliases
  antigen bundle compleat
  antigen bundle zoxide
  antigen bundle macos
  antigen bundle atuinsh/atuin@main
  antigen bundle zsh-users/zsh-history-substring-search
  antigen bundle zsh-users/zsh-autosuggestions
  antigen bundle zsh-users/zsh-syntax-highlighting
  antigen apply
else
  echo "Antigen not found, please install it"
fi

alias cleanup="dua interactive /"
alias vim=nvim
alias v=nvim
alias vv=nvim
alias nv="NO_RUST_LSP=1 nvim"
alias nvv="NO_RUST_LSP=1 nvim"
alias ..="cd .."
alias ...="cd ../.."
alias clip="nc localhost 8377"

# local scripts
export PATH="$PATH:$HOME/.local/scripts:$HOME/github/git-pile/bin"

# mason bin
export PATH="$HOME/.local/share/nvim/mason/bin:$PATH"

# clangd
export PATH="/usr/local/opt/llvm/bin:$PATH"

# Deno
export DENO_INSTALL="$HOME/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"
[ -s "$DENO_INSTALL/env" ] && source "$DENO_INSTALL/env"

# GO
export PATH=$PATH:/usr/local/go/bin

# Rust
export CARGO_NET_GIT_FETCH_WITH_CLI=true

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
[ -s "$BUN_INSTALL/_bun" ] && source "$BUN_INSTALL/_bun"

# Node 
eval "$(fnm env --use-on-cd --shell zsh --log-level=quiet)"

cargo-targets() {
  cargo metadata --format-version 1 | jq -r '.packages[].targets[].name'
}

# Use a prefix with git-pile
# see https://github.com/keith/git-pile#optional
export PATH="$PATH:$HOME/.local/scripts:$HOME/github/git-pile/bin"
export GIT_PILE_PREFIX=pg/

# Set up fzf key bindings and fuzzy completion
export FZF_CTRL_T_OPTS="--preview='bat --color=always --style=numbers {}' --bind ctrl-u:preview-page-up,ctrl-d:preview-page-down"
export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --exclude .git'
export FZF_CTRL_T_COMMAND='rg --no-messages --files'
eval "$(fzf --zsh)"

# work config
[ -f $HOME/.private/init.zsh ] && source $HOME/.private/init.zsh

# Add local scripts to path
export PATH="$HOME/.dotfiles/bin/.local/scripts:$PATH"

# Atuin
export PATH="$PATH:/Users/pg/.atuin/bin"
eval "$(atuin init zsh)"

# Open gh url
gh-pr-view(){
  gh pr view --web
} 

# open a devops issue 
gh-devops() {
  gh issue -R paritytech/devops create --title "Deploy eth-rpc"
}

# Init a PR with prdoc and label
gh-pr-init(){
  PR_NUMBER=$(gh pr view --json number --jq '.number' | xargs)
  gh pr comment $PR_NUMBER --body "/cmd prdoc --audience runtime_dev --bump minor"
  gh pr edit $PR_NUMBER --add-label "T7-smart_contracts" --add-label "R0-silent"
}

# Open failing job
gh-failing-job() {
# jobs=$(gh pr checks --json "event,completedAt,name,link,description,state" | jq -r '[.[] | select(.state == "FAILURE" and .name != "review-bot")] | sort_by(.completedAt)')
  jobs=$(gh pr checks --json "event,completedAt,name,link,description,state" | jq -r '[.[] | select(.state == "FAILURE")] | sort_by(.completedAt)')
  selected=jobs | fzf
}

# Select a PR to checkout 
gh-pr-co(){
  local use_all="$1"
  local SELECTED_PR

  if [ "$use_all" = "all" ]; then
    SELECTED_PR=$(gh pr list | fzf)
  else
    SELECTED_PR=$(gh pr list --author "@me" | fzf)
  fi

  local PR=$(echo "$SELECTED_PR" | awk '{print $1;}')
  gh pr checkout $PR
}

git-recent(){
  local branch=$(git branch --sort=-committerdate --format="%(refname:short)" | head -5 | fzf)
  git checkout $branch
}

start_mitmproxy() {
  # Default port to 8546 if not provided
  local port="${1:-8546}"
  
  # Check if a tmux session/window named 'mitmproxy' exists
  if ! tmux list-windows -t $(tmux display-message -p '#S') | grep -q "mitmproxy"; then
    # If not, create the window
    tmux new-window -n mitmproxy
  fi
  
  
  # Send the commands to the tmux window
  tmux send-keys -t mitmproxy "cd $HOME/github/mitmproxy" C-m
  tmux send-keys -t mitmproxy "source venv/bin/activate" C-m
  tmux send-keys -t mitmproxy "mitmproxy --listen-port 8000 --mode reverse:http://localhost:${port} -s $HOME/github/mitm-playground/init.py" C-m
}

hex_to_bytes() {
  echo $1 | xxd -r -p | od -t x1 -An
  echo $1 | xxd -r -p | od -A n -t u1 
}

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f $HOME/.p10k.zsh ]] || source $HOME/.p10k.zsh
