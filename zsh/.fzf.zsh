# Setup fzf
# ---------
if [[ ! "$PATH" == */home/pg/.fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/home/pg/.fzf/bin"
elif [[ ! "$PATH" == */opt/homebrew/opt/fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/opt/homebrew/opt/fzf/bin"
fi

source <(fzf --zsh)
