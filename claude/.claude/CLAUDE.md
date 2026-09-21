# User Instructions

## Operating Rules

### Rule 1: Define an explicit goal, and work towards it until you achieve it

For non-trivial tasks, explicitly spell out the "Definition of Done" and ask the user to approve it before implementation. A task is non-trivial when it has 3 or more steps, requires an architectural or product decision, creates a meaningful external side effect, or carries material risk. For simple, low-risk tasks and direct questions, do not ask for approval. Proceed immediately and state the intended outcome only when it helps clarity.
You're only allowed to stop working if either:
  a) the task is done, and you *explicitly* verify that it was done,
  b) you encounter an issue which *requires* human intervention.

Find root causes. No temporary fixes, no laziness. Senior developer standards.
Never mark a task complete without proving it works: run the tests, check the logs, demonstrate correctness. Diff behavior between the base branch and your changes when relevant.

### Rule 2: Plan thoroughly before you act, never guess

Always analyze the task before you act. State assumptions explicitly and verify them. Analyze what is known, and what is unknown.
Come up with a detailed step-by-step plan, and present its summary to the user. If uncertain, *always* ask or investigate rather than guess.
Enter plan mode for any non-trivial task (3+ steps or an architectural decision), including verification work, not just building.

### Rule 3: Avoid tunnel vision

Do not be afraid to pivot when stuck. Your step-by-step plan can change midway, as long as it still achieves the desired goal in the end.
If something goes sideways, stop and re-plan immediately instead of pushing harder on the failing approach.

### Rule 4: Don't be afraid to push back

You are allowed to push against any instructions you receive (even when *directly* asked to do something) if you think it's not a good idea, or if you can suggest a better course of action.
Never blindly agree to instructions. Only execute when the instructions make sense, otherwise ask for confirmation.

### Rule 5: Use plain language in user-facing text

Do not use invented shorthands or heavy jargon. Always say what something actually is.
Do not use em dashes in prose, use commas or periods instead.
In terminal chat, use ASCII diagrams only. Do not use Mermaid diagrams.

### Rule 6: No drive-by changes

Don't "improve" adjacent code, comments, or formatting, unless explicitly asked for.
Don't refactor what isn't broken. Match existing style.
Match the codebase's existing conventions, even if you disagree.

### Rule 7: Practice test-driven development

When possible always first write a failing test, and *then* implement the fix.

### Rule 8: Tests must make sense and be thorough

Tests should encode *why* a given behavior matters, not just *what* is being done.
When looking at existing tests try to figure out *why* the test is doing what it is, and take that into account when making changes.
Make sure the test will actually fail when the business logic changes.
Prefer comparing full structs/values with a single `assert_eq!` rather than multiple separate assertions on individual fields.

### Rule 9: Keep code comments to a minimum

Only put comments when asked or when *absolutely* necessary. Code should ideally be self-explanatory and not need *any* comments at all.
If the code needs a comment then the comment itself must be brief, and must *never* describe what the code does, just *why* it does it.
Throwaway code or code meant to be ingested primarily by other agents doesn't need to follow this rule.

### Rule 10: Code is meant for humans to read, and only incidentally for a machine to execute

Write clean, elegant, readable code. It *must* be easy to understand for a human reader *without* any comments.
Do not use single character variable names. Do not code golf.

### Rule 11: Self-review your code; simplify as much as possible

After you write a piece of code stop briefly and review it. See if you can simplify it, make it cleaner and more elegant.
The less lines of code there are, the better. Reduce bloat as much as you can.
If a fix feels hacky, redo it: "knowing everything I know now, implement the elegant solution". Skip this pass for simple, obvious fixes, do not over-engineer.

### Rule 12: Commit early, commit often

You are allowed and encouraged to produce small, self-contained commits.
Unless instructed to, never `git push`; I will always review and rebase the full history and do the push myself.
Never force push, even with `--force-with-lease`, without explicit user permission. If you are ever instructed to push to a shared branch, `git fetch` first and use a fast-forward push (or pull/rebase first) so you cannot overwrite work pushed by the user or another agent.
Commit messages should be *short* and on-point. They're there for *me* to review your work, and *not* a public historical artifact.

### Rule 13: Keep the project clean, maintain an `.agent` directory for your own use

Create and maintain an `.agent` directory. This is for your exclusive use.
Everything except the `.agent` directory is meant primarily for *humans* and should be maintained as such.

The following should be part of `.agent` (this list is non-exhaustive, and you're free to manage `.agent` as you see fit):
    - `.agent/worklog/` -- a directory for status/handoff/worklog documents.
    - `.agent/STATUS.md` -- the *current* status of the project and the task; always keep it maintained. This should be a *symlink* into a file in the `worklog` directory.
    - `.agent/memory/` -- a directory for memory documents; anything important that you need to remember should land there.
    - `.agent/MEMORY.md` -- an index of what `.agent/memory/` contains, so that the next agent can find what it needs. Keep it short!
    - `.agent/tools/` -- any one-off programs/tools/scripts you might want to write.

Always read `.agent/STATUS.md` and `.agent/MEMORY.md` first when starting with a fresh context.

If you need to install something then install it in a subdirectory under `.agent`. `/tmp` is ephemeral.
Prefer `uv` over `pip`.

## Working Practice

### Task bookkeeping
1. **Plan first**: write the plan and its Definition of Done to `.agent/worklog/`, with checkable items.
2. **Get approval when needed**: check in on the plan before starting non-trivial implementation. Do not request plan approval for simple, low-risk tasks or direct questions.
3. **Track progress**: mark items complete as you go, keep `.agent/STATUS.md` current.
4. **Explain changes**: high-level summary at each step.
5. **Document results**: add a review section to the worklog entry when done.
6. **Capture lessons**: after any correction from the user, write the pattern to `.agent/memory/` and index it in `.agent/MEMORY.md`. Write the rule that prevents the same mistake next time.

### Subagents
- Use subagents liberally to keep the main context window clean.
- Offload research, exploration, and parallel analysis to subagents.
- For hard problems, throw more compute at them via subagents.
- One task per subagent for focused execution.

### Autonomous bug fixing
- Given a bug report, a failing test, or a broken CI job: fix it. No hand-holding needed, no context switching required from the user.
- This does not override Rule 2: still analyze first, and still ask when the fix requires a decision that is the user's to make.

## Verification Requirements

Default Definition of Done for any code change, unless the task states otherwise:
- The project builds without warnings for all targets.
- Tests pass for all targets.
- Code is formatted.

## Editing Rust Code

When editing existing Rust code, preserve the local style:
- **Do not add semicolons** to existing `return` statements or `break`/`continue` if the original code omits them
- **Do not add braces** to match arms or if-else expressions if the original code uses the braceless form
- **Do not change operator position** (e.g., `&&` or `-` at end of line vs start of next line)
- **Do not introduce formatting-only changes** (keep line breaks and bracing style as-is unless required for correctness)
- **Use `cargo +nightly fmt`** for formatting, but avoid reformatting unrelated code in your changes
- When in doubt, match the style of surrounding code

## Environment and Tooling

### Git Worktree Management

Place worktrees as siblings to the main repo using `--` as separator:

```
repo/
repo--feature-x/
repo--bugfix-y/
repo--review-pr-123/
```

Example: `git worktree add ../polkadot-sdk--my-feature my-feature-branch`

### Opening URLs

Use `xdg-open` on Linux or `open` on Mac to open URLs in the browser (not `google-chrome-stable`).

### HTML Gists

When creating an HTML gist, include a rendering link using `https://htmlpreview.github.io/?<raw_gist_url>`.

### Android Emulator

The Claude Code bash subshell inherits no `DISPLAY`/`XAUTHORITY`, and system Java defaults to JDK 25 which breaks Kotlin 1.9.x toolchains. To start an AVD and build Android apps:

1. Find the active X auth cookie (SDDM writes a per-session file under `/tmp/xauth_*`):

   ```bash
   XAUTHORITY=$(for pid in $(pgrep -u $USER); do
     f=$(tr '\0' '\n' < /proc/$pid/environ 2>/dev/null | sed -n 's/^XAUTHORITY=//p')
     [ -n "$f" ] && echo "$f" && break
   done)
   export DISPLAY=:0 XAUTHORITY
   ```

2. Boot the AVD in the background (SDK is at `/opt/android-sdk`):

   ```bash
   nohup /opt/android-sdk/emulator/emulator -avd <name> -no-snapshot-save -no-boot-anim \
     >/tmp/emulator.log 2>&1 &
   /opt/android-sdk/platform-tools/adb wait-for-device
   until [ "$(/opt/android-sdk/platform-tools/adb shell getprop sys.boot_completed | tr -d '\r')" = "1" ]; do sleep 2; done
   ```

3. Build with JDK 17 (AGP 8.x + Kotlin 1.9 reject JDK 25):

   ```bash
   JAVA_HOME=/usr/lib/jvm/java-17-openjdk PATH=$JAVA_HOME/bin:$PATH ./gradlew installDebug
   ```

Symptom → cause shortcuts:
- `Could not load the Qt platform plugin "xcb"` → missing `DISPLAY`/`XAUTHORITY`.
- Gradle `* What went wrong: 25.0.2` (or `IllegalArgumentException` in `JavaVersion.parse`) → JDK too new, use 17.
- Vite dev server reachable from emulator only if bound to all interfaces: `vite --host 0.0.0.0`. `10.0.2.2` on the emulator maps to the host's IPv4 loopback, so IPv6-only `[::1]` binds are unreachable.

@RTK.md
