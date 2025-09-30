[ -f $HOME/.cargo/env ] && source "$HOME/.cargo/env" 

export SSH_SERVER=toaster
export EDITOR=nvim
export HISTCONTROL=ignoreboth
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export PATH="$HOME/.local/bin:$PATH"

if [[ "$(uname)" == "Darwin" && -S ~/.1password/agent.sock ]]; then
  export SSH_AUTH_SOCK=~/.1password/agent.sock
fi

export PATH="$PATH:/$HOME/.foundry/bin"
