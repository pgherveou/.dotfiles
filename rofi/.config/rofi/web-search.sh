#!/bin/bash

declare -A websites=(
    ["Substrate"]="https://paritytech.github.io/polkadot-sdk/master/index.html?search="
    ["Rust std"]="https://doc.rust-lang.org/std/index.html?search="
    ["Rust docs"]="https://docs.rs/"
)

# Generate a list of search engine names for Rofi
options=$(printf "%s\n" "${!websites[@]}")

# Show Rofi menu and get the selected engine
selected=$(echo "$options" | rofi -dmenu -i -p "Search:")

# If a selection was made
if [ -n "$selected" ]; then
    # Prompt for the search query
    query=$(rofi -dmenu -p "$selected:")

    # If a query was entered, open it in the default browser
    if [ -n "$query" ]; then
        if [[ -n "${websites[$selected]}" ]]; then
            url="${websites[$selected]}${query// /+}"
        else
            url="https://www.google.com/search?q=${selected// /+}"
        fi
        xdg-open "$url"
    fi
fi

