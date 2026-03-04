# User Instructions

- Do not comment obvious things, keep comments short and on point
- When editing existing code, preserve the local style

### Editing Rust Code

When editing existing Rust code, preserve the local style:
- **Do not add semicolons** to existing `return` statements or `break`/`continue` if the original code omits them
- **Do not add braces** to match arms or if-else expressions if the original code uses the braceless form
- **Do not change operator position** (e.g., `&&` or `-` at end of line vs start of next line)
- **Do not introduce formatting-only changes** (keep line breaks and bracing style as-is unless required for correctness)
- **Use `cargo +nightly fmt`** for formatting, but avoid reformatting unrelated code in your changes
- When in doubt, match the style of surrounding code

### Testing

- Prefer comparing full structs/values with a single `assert_eq!` rather than multiple separate assertions on individual fields

### Verification Requirements

- After any code change, ensure the project builds without warnings for all targets
- Ensure tests pass for all targets
- Ensure code is formatted

### node-env (Revive dev environments)

`node-env` is on PATH — use it to manage Polkadot Revive dev nodes, eth-rpc bridges, and tmux stacks. Source: `~/github/node-env`.

Slash commands are available globally: `/dev-stack`, `/anvil-stack`, `/westend-stack`, `/paseo-stack`, `/geth-stack`, `/kill-servers`, `/logs`, `/node-env`.

If `node-env` is not found, tell the user to add `~/github/node-env/bin` to their PATH.

### Git Worktree Management

Place worktrees as siblings to the main repo using `--` as separator:

```
repo/
repo--feature-x/
repo--bugfix-y/
repo--review-pr-123/
```

Example: `git worktree add ../polkadot-sdk--my-feature my-feature-branch`
