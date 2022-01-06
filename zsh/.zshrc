# OSX antigen file
source /opt/homebrew/share/antigen/antigen.zsh

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

# Load the theme
antigen bundle mafredri/zsh-async
antigen bundle sindresorhus/pure@main

# Bundles from the default repo (robbyrussell's oh-my-zsh).
antigen bundle git
antigen bundle command-not-found
antigen bundle brew
antigen bundle common-aliases
antigen bundle compleat
antigen bundle git-extras
antigen bundle bazel
antigen bundle npm
antigen bundle macos
antigen bundle zsh-users/zsh-history-substring-search
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-syntax-highlighting

# Tell Antigen that you're done.
antigen apply
alias vim=nvim
alias ..="cd .."
alias ...="cd ../.."
alias vimrc="vim ~/.config/nvim/init.vim"
alias vimbbl="vim ~/src/bbl"
export EDITOR=vim

# Deno
export DENO_INSTALL="$HOME/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"

# GO
export PATH="$HOME/go/bin:$PATH"

# Rust
export PATH="$HOME/.cargo/bin:$PATH"
export CARGO_NET_GIT_FETCH_WITH_CLI=true

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

# fzf config
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# work config
[ -f ~/.work.zsh ] && source ~/.work.zsh
