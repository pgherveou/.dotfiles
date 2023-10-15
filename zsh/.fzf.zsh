# Setup fzf
# ---------
if [[ ! "$PATH" == */opt/homebrew/opt/fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/opt/homebrew/opt/fzf/bin"
fi

# Auto-completion
# ---------------
# on macOS use base_path /opt/homebrew/opt/fzf/shell, on Debian use /usr/share/fzf/examples/

OS=$(uname -s)
[ "$OS" = "Darwin" ] && BASE_PATH="/opt/homebrew/opt/fzf/shell" || BASE_PATH="/usr/share/doc/fzf/examples"
[[ $- == *i* ]] && source "$BASE_PATH/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "$BASE_PATH/key-bindings.zsh"
