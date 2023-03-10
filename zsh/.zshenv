[ -f $HOME/.cargo/env ] && source "$HOME/.cargo/env" 
. "$HOME/.cargo/env"

# returns if the current window is zoomed
function yabai_is_zoomed {
  local zoomed=$(yabai -m query --windows --window | jq -r '."has-fullscreen-zoom"')
  [[ $zoomed == "true" ]]
}


# returns if there are other window on the display
function yabai_has_other_windows {
  local count=$(yabai -m query --windows --display | jq 'length > 1')
  [[ $count == "true" ]]
}

# returns if the current window is zoomed or the only window on the display
function yabai_is_zoomed_or_solo {
  yabai_is_zoomed || ! yabai_has_other_windows
}

# returns the id of the current window
function yabai_cur_window_id {
	yabai -m query --windows --window | jq '.id'
}

# returns the next display or the first
function yabai_next_display {
  local cur_display=$(yabai -m query --displays --display | jq '.index')
  local next_display=$((cur_display + 1))
  local num_displays=$(yabai -m query --displays | jq 'length')
  [[ $next_display -gt $num_displays ]] && next_display=1
  echo $next_display
}


