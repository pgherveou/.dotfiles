#!/bin/bash

# time used to configure the --time option for cargo sweep
time="${1:-10}"

# Array of top-level directories to check
dir_array=(
	"$HOME/github"
	"$HOME/github/pba"
	"$HOME/github/ink-examples"

)

# Function to check if a folder is a Rust project and the target directory exists
is_rust_project_with_target() {
	# Check if the folder contains a Cargo.toml file and the 'target' directory exists
	[[ -f "$1/Cargo.toml" && -d "$1/target" ]]
}

# Iterate through the top-level directories in the array
for top_level_dir in "${dir_array[@]}"; do
	# Iterate through all directories inside the top-level directory
	for dir in "$top_level_dir"/*; do
		if is_rust_project_with_target "$dir"; then
			echo "Running 'cargo sweep' in $dir"
			cd "$dir" || continue
			cargo sweep --time "$time"
		fi
	done
done
