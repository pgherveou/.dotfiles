[ -f $HOME/.cargo/env ] && source "$HOME/.cargo/env" 
. "$HOME/.cargo/env"

# https://developer.1password.com/docs/ssh/get-started#step-4-configure-your-ssh-or-git-client
# export SSH_AUTH_SOCK=~/.1password/agent.sock

export PATH="$PATH:/Users/pg/.foundry/bin"
export PATH="$PATH:/Users/pg/.atuin/bin"
export PATH="$HOME/.local/bin:$PATH"

export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
