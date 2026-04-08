export EDITOR=nvim
export HISTCONTROL=ignoreboth
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export PATH="$HOME/.local/bin:$PATH"
export POLKADOT_SDK_DIR="$HOME/polkadot-sdk"

if [[ "$(uname)" == "Darwin" && -S ~/.1password/agent.sock ]]; then
  export SSH_AUTH_SOCK=~/.1password/agent.sock
fi

[ -f $HOME/.cargo/env ] && source "$HOME/.cargo/env" 

export PATH="$PATH:/home/pg/.foundry/bin"

export CLAUDE_CODE_DISABLE_ADAPTIVE_THINKING=1

