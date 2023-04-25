[ -f $HOME/.cargo/env ] && source "$HOME/.cargo/env" 
. "$HOME/.cargo/env"

# https://developer.1password.com/docs/ssh/get-started#step-4-configure-your-ssh-or-git-client
# export SSH_AUTH_SOCK=~/.1password/agent.sock

# returns if the current window is zoomed
function yabai_is_zoomed {
  local zoomed=$(yabai -m query --windows --window | jq -r '."has-fullscreen-zoom"')
  [[ $zoomed == "true" ]]
}

# returns the id of the current window
function yabai_cur_window_id {
	yabai -m query --windows --window | jq '.id'
}

function yabai_cur_display {
  echo $(yabai -m query --displays --display | jq '.index')
}

# returns the next display or the first
function yabai_next_display {
  local cur_display=$(yabai -m query --displays --display | jq '.index')
  local next_display=$((cur_display + 1))
  local num_displays=$(yabai -m query --displays | jq 'length')
  [[ $next_display -gt $num_displays ]] && next_display=1
  echo $next_display
}

# return the previous display or the last
function yabai_prev_display {
  local cur_display=$(yabai -m query --displays --display | jq '.index')
  local prev_display=$((cur_display - 1))
  [[ $prev_display -lt 1 ]] && prev_display=$(yabai -m query --displays | jq 'length')
  echo $prev_display
}

# Function to focus and move a window by application name
function yabai_move_or_launch_app() {
  app_name="$1"
  target_space="$2"
  shift 2
  app_args="$*"

  app_running=$(pgrep "$app_name")
  if [ -n "$app_running" ]; then
    app_window=$(yabai -m query --windows --display | jq -r "map(select(.app == \"$app_name\"))[0] | .id")
    if [ -n "$app_window" ]; then
      yabai -m window "$app_window" --space "$target_space"
    else
      yabai -m space --focus "$target_space"
      open -a "$app_name" --args $app_args && sleep 1
    fi
  else
    yabai -m space --focus "$target_space"
    open -a "$app_name" --args $app_args && sleep 1
  fi

  yabai -m space --focus "$target_space"
  yabai -m window --toggle zoom-fullscreen
}
