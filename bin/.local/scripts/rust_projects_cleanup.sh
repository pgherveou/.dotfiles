#!/bin/bash

# time used to configure the --time option for cargo sweep
time="${1:-10}"

# days threshold for considering worktree stale (default: 30 days)
stale_days="${2:-30}"

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

# Function to check if directory is a git worktree (has .git file with gitdir pointer)
is_git_worktree() {
	[[ -f "$1/.git" ]] && grep -q "^gitdir:" "$1/.git" 2>/dev/null
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

# Clean target dirs in worktrees
echo ""
echo "Scanning for worktrees with dots in name (stale feature branches)..."
for top_level_dir in "${dir_array[@]}"; do
	for dir in "$top_level_dir"/*; do
		basename=$(basename "$dir")
		# Detect worktrees: has .git file with gitdir AND name contains dot (feature branch pattern)
		if [[ -d "$dir" && "$basename" == *.* && "$dir" != "$top_level_dir" ]]; then
			if is_git_worktree "$dir"; then
				if [[ -d "$dir/target" ]]; then
					target_size=$(du -sh "$dir/target" 2>/dev/null | awk '{print $1}')
					echo "Removing target ($target_size) from $basename"
					rm -rf "$dir/target"
				fi
			fi
		fi
	done
done
