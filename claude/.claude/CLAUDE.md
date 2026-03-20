# User Instructions

- Do not comment obvious things, keep comments short and on point
- When editing existing code, preserve the local style
- Do not use em dashes (—) in prose, use commas or periods instead

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

### polkadot-sdk PR Workflow

After creating and pushing a PR to `polkadot-sdk`, run `gh-pr-init` to set the `T7-smart_contracts` label and request a prdoc from the bot. Usage: `gh-pr-init [level]` where level defaults to `patch` (options: `patch`, `minor`, `major`). Ask the user which bump level to use if unclear.

### Opening URLs

Use `xdg-open` on Linux or `open` on Mac to open URLs in the browser (not `google-chrome-stable`).

### Git Worktree Management

Place worktrees as siblings to the main repo using `--` as separator:

```
repo/
repo--feature-x/
repo--bugfix-y/
repo--review-pr-123/
```

Example: `git worktree add ../polkadot-sdk--my-feature my-feature-branch`

## Working Style

### 1. Plan Node Default
- Enter plan mode for ANY non-trivial task (3+ steps or architectural decisions)
- If something goes sideways, STOP and re-plan immediately - don't keep pushing
- Use plan mode for verification steps, not just building
- Write detailed specs upfront to reduce ambiguity

### 2. Subagent Strategy
- Use subagents liberally to keep main context window clean
- Offload research, exploration, and parallel analysis to subagents
- For complex problems, throw more compute at it via subagents
- One task per subagent for focused execution

### 3. Self-Improvement Loop
- After ANY correction from the user: update `tasks/lessons.md` with the pattern
- Write rules for yourself that prevent the same mistake
- Ruthlessly iterate on these lessons until mistake rate drops
- Review lessons at session start for relevant project

### 4. Verification Before Done
- Never mark a task complete without proving it works
- Diff behavior between main and your changes when relevant
- Ask yourself: "Would a staff engineer approve this?"
- Run tests, check logs, demonstrate correctness

### 5. Demand Elegance (Balanced)
- For non-trivial changes: pause and ask "is there a more elegant way?"
- If a fix feels hacky: "Knowing everything I know now, implement the elegant solution"
- Skip this for simple, obvious fixes - don't over-engineer
- Challenge your own work before presenting it

### 6. Autonomous Bug Fixing
- When given a bug report: just fix it. Don't ask for hand-holding
- Point at logs, errors, failing tests - then resolve them
- Zero context switching required from the user
- Go fix failing CI tests without being told how

## Task Management
1. **Plan First**: Write plan to `tasks/todo.md` with checkable items
2. **Verify Plan**: Check in before starting implementation
3. **Track Progress**: Mark items complete as you go
4. **Explain Changes**: High-level summary at each step
5. **Document Results**: Add review section to `tasks/todo.md`
6. **Capture Lessons**: Update `tasks/lessons.md` after corrections

## Core Principles
- **Simplicity First**: Make every change as simple as possible. Impact minimal code
- **No Laziness**: Find root causes. No temporary fixes. Senior developer standards
