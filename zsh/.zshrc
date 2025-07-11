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

# if linux alias open=xdg-open
if [[ $(uname) == "Linux" ]]; then
  alias open=xdg-open
fi

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

# resolc bin
export RESOLC_BIN=$HOME/.cargo/bin/resolc

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



# custom llvm
# export PATH="$PATH:$HOME/github/revive/llvm18.0/bin/"

# Open gh url
gh-pr-view(){
  gh pr view --web
} 

# Init a PR with prdoc and label
gh-pr-init(){
  # level default to patch
  LEVEL=${1:-patch}
  PR_NUMBER=$(gh pr view --json number --jq '.number' | xargs)
  gh pr comment $PR_NUMBER --body "/cmd prdoc --audience runtime_dev --bump $LEVEL"
  gh pr edit $PR_NUMBER --add-label "T7-smart_contracts"
}

# call fmt
gh-pr-fmt(){
  PR_NUMBER=$(gh pr view --json number --jq '.number' | xargs)
  gh pr comment $PR_NUMBER --body "/cmd fmt"
}


# Bench pallet-revive
gh-pr-bench(){
  PR_NUMBER=$(gh pr view --json number --jq '.number' | xargs)
  PALLET=${1:-pallet_revive}
  gh pr comment $PR_NUMBER --body "/cmd bench --runtime dev --pallet $PALLET"
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
  local branch=$(git branch --sort=-committerdate --format="%(refname:short)" | head -15 | fzf)
  git checkout $branch
}

start_mitmproxy() {
  local ports="${1:-8000:8545}"
  IFS=":" read listen_port proxy_port <<< "$ports"
  
  pkill -f mitmproxy
  tmux new-window -d -n mitmproxy "cd $HOME/github/mitmproxy; source venv/bin/activate; mitmproxy --listen-port $listen_port --mode reverse:http://localhost:${proxy_port} -s $HOME/github/mitmproxy/scripts/json-rpc.py; tmux wait-for -S mitmproxy-done"
}

hex() {
  printf '%x' "$1"
}

hex_to_dec() {
  # Check if input is provided
  if [[ -z "$1" ]]; then
    echo "Usage: hex_to_dec <hexadecimal_number>"
    return 1
  fi

  # Convert hexadecimal to decimal
  local hex="$1"
  local decimal=$((hex))

  # Output the decimal value
  echo "$decimal"
}

hex_to_bytes() {
  echo $1 | xxd -r -p | od -t x1 -An
  echo $1 | xxd -r -p | od -A n -t u1 
}

dunst_history() {
  dunstctl history | jq -r '.data[][0] | {body: .body.data, summary: .summary.data, id: .id.data}'
}

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f $HOME/.p10k.zsh ]] || source $HOME/.p10k.zsh

fkill() {
  local pid
  if [[ -z "$1" ]]; then
    echo "Usage: fkill <process_name>"
    return 1
  fi

  pid=$(pgrep -fi "$1" | fzf --prompt="Select process to kill: " --preview='ps -p {} -o pid,user,comm,args' --preview-window=down:4:wrap)

  if [[ -n "$pid" ]]; then
    kill -9 "$pid" && echo "Killed process $pid"
  else
    echo "No process selected."
  fi
}


my_past_pr() {
  DATE_STR=${1:-'6 months ago'}
  DATE=$(date -d $DATE_STR +%Y-%m-%d)

  REPO=${2:-paritytech/polkadot-sdk}

  gh api --paginate "search/issues?q=repo:$REPO+type:pr+state:closed+author:@me+closed:>=$DATE" \
    | jq -r '.items[] | "[#\(.number)](\(.html_url)) - \(.title)"'
}
