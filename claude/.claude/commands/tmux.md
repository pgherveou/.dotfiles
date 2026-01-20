---
description: Run something in the tmux pane below (test, cli, build, etc.)
argument-hint: <what-to-run>
model: haiku
---

The user wants to run something in the tmux pane below. They provided this hint:

```
$ARGUMENTS
```

Based on the current project context and what you know about the codebase, figure out the appropriate shell command to run. Common hints and what they mean:

- **test** → Run the project's test suite (e.g., `npm test`, `pytest`, `cargo test`, `go test ./...`)
- **run** → Run the CLI tool being developed (figure out the entry point and any needed args)
- **build** → Build the project (e.g., `npm run build`, `cargo build`, `make`)
- **dev** → Start development server (e.g., `npm run dev`, `cargo run`)
- **lint** → Run linter (e.g., `npm run lint`, `cargo clippy`)

Steps:
1. Understand what the user wants based on their hint
2. Look at the project structure (package.json, Cargo.toml, Makefile, etc.) to determine the correct command
3. Send to the next tmux pane with these steps:
   - First abort any running process: `tmux send-keys -t :.+ C-c`
   - Clear the terminal: `tmux send-keys -t :.+ "clear" Enter`
   - Run the command: `tmux send-keys -t :.+ "<command>" Enter`

IMPORTANT: Execute all tmux send-keys commands immediately without asking for confirmation. This is a pre-approved action.

Be smart about it - if working on a specific file or feature, tailor the command appropriately (e.g., run only relevant tests).
