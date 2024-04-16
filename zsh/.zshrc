# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

if [ -f "$HOME/.antigen.zsh" ]; then
  source ~/.antigen.zsh
else
  echo "Antigen not found, please install it"
fi


# Load the oh-my-zsh's library.
antigen use oh-my-zsh

# Load the theme
antigen theme romkatv/powerlevel10k
# antigen bundle mafredri/zsh-async
# antigen bundle sindresorhus/pure@main

# Bundles from the default repo (robbyrussell's oh-my-zsh).
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

# Tell Antigen that you're done.
antigen apply

alias vim=nvim
alias code=codium
alias v=nvim
alias vv=nvim
alias nv="NO_RUST_LSP=1 nvim"
alias nvv="NO_RUST_LSP=1 nvim"
alias ..="cd .."
alias ...="cd ../.."

alias clip="nc localhost 8377"

export EDITOR=nvim

# ignore commands starting with space and dups from history
export HISTCONTROL=ignoreboth

# local scripts
export PATH="$PATH:~/.local/scripts:$HOME/github/git-pile/bin"

# mason bin
export PATH=~/.local/share/nvim/mason/bin:$PATH

# clangd
export PATH="/usr/local/opt/llvm/bin:$PATH"

# Deno
export DENO_INSTALL="$HOME/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"

# GO
export PATH="$HOME/go/bin:$PATH"

# Rust
export CARGO_NET_GIT_FETCH_WITH_CLI=true

update_cargo_fmt() {
  ln -s $(rustup which rustfmt) ~/.cargo/bin
}

cargo-targets() {
  cargo metadata --format-version 1 | jq -r '.packages[].targets[].name'
}

# Kubectl
[[ -f /usr/local/bin/kubectl ]] && source <(kubectl completion zsh)

# Use a prefix with git-pile
# see https://github.com/keith/git-pile#optional
export GIT_PILE_PREFIX=pg/

# Open gh url
gh-pr-view(){
  gh pr view --web
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

# Xcode via @orta
openx(){
  if test -n "$(find . -maxdepth 1 -name '*.xcworkspace' -print -quit)"
  then
    echo "Opening workspace"
    open *.xcworkspace
    return
  else
    if test -n "$(find . -maxdepth 1 -name '*.xcodeproj' -print -quit)"
    then
      echo "Opening project"
      open *.xcodeproj
      return
    else
      echo "Nothing found"
    fi
  fi
}

hex_to_bytes() {
  echo $1 | xxd -r -p | od -t x1 -An
  echo $1 | xxd -r -p | od -A n -t u1 
}

# bazel
alias bazel=bazelisk
# compdef bazelisk=bazel

# Envoy exports required for make_format 
export BUILDIFIER_BIN=$(which buildifier)
export BUILDOZER_BIN=$(which buildozer)
export CLANG_FORMAT=$(which clang-format)

# Set up fzf key bindings and fuzzy completion
eval "$(fzf --zsh)"

export FZF_CTRL_T_OPTS="--preview='bat --color=always --style=numbers {}' --bind ctrl-u:preview-page-up,ctrl-d:preview-page-down"
export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --exclude .git'
export FZF_CTRL_T_COMMAND='rg --no-messages --files'

# work config
[ -f ~/.private/init.zsh ] && source ~/.private/init.zsh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


eval "$(atuin init zsh)"
