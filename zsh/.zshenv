export EDITOR=nvim
export HISTCONTROL=ignoreboth
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export PATH="$HOME/.local/bin:$PATH"
export POLKADOT_SDK_DIR="$HOME/polkadot-sdk"

# ~/.cargo is a stow symlink into this repo. Cargo must use the physical path, or
# crates resolving paths relative to CARGO_MANIFEST_DIR (askama's derive, reached
# via uniffi) emit a ../ walk that the kernel resolves two levels short and the
# build fails on a path that cannot exist.
[ -d "$HOME/.cargo" ] && export CARGO_HOME="$(cd -P "$HOME/.cargo" && pwd)"

[ -f $HOME/.cargo/env ] && source "$HOME/.cargo/env"

export PATH="$PATH:/home/pg/.foundry/bin"

if [[ "$(uname)" == "Darwin" ]]; then
  export ANDROID_HOME="/opt/homebrew/share/android-commandlinetools"
  export ANDROID_SDK_ROOT="$ANDROID_HOME"
  # host-rust-core pins JDK 21 for hosts/android and JDK 17 for the android/ AARs
  export JAVA_HOME="/opt/homebrew/opt/openjdk@21/libexec/openjdk.jdk/Contents/Home"
  export JAVA_17_HOME="/opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk/Contents/Home"
  export PATH="$JAVA_HOME/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/emulator:$PATH"
  # rust-android-gradle generates a linker wrapper that shells out to `python`,
  # which macOS no longer ships. Homebrew keeps that name in python's libexec.
  export PATH="$PATH:/opt/homebrew/opt/python@3.13/libexec/bin"
fi

export CLAUDE_CODE_DISABLE_ADAPTIVE_THINKING=1

