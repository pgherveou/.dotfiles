---
name: split-pr
description: Split the current branch's diff into a stack of smaller PRs using gh-stack. Each layer compiles, tests, and passes CI on its own. Works with or without an existing PR. Pass a PR number to supersede it at the end, or omit it to carve a working branch into a fresh stack.
argument-hint: "[optional: pr-number-to-supersede]"
disable-model-invocation: false
---

# Split Current Branch Into a Stack

Carve the current branch's diff against `origin/main` into a `gh stack` of smaller, independently reviewable PRs. The source branch stays untouched. You can keep working from it after the stack lands and run `/restack-pr` later to dispatch new changes.

`$ARGUMENTS` is optional. Pass a PR number to mark that PR superseded once the stack is up and green. Omit it if no PR exists yet (you're splitting a working branch directly).

## Prerequisites

`gh stack` mechanics run through the bundled `gh-stack` skill (vendored from [github/gh-stack](https://github.com/github/gh-stack); see `skills/gh-stack/NOTICE.md`). For any `gh stack` operation, invoke the `gh-stack` skill. Do not call `gh stack` directly.

Required setup (one-time):

```sh
gh extension install github/gh-stack
```

The repo must also be enrolled in the stacked-PRs preview (sign up at https://gh.io/stacksbeta).

If the `gh stack` extension is missing or the `gh-stack` skill is not loadable, stop on Step 0 and surface install steps.

## Defaults

- **Max 5 layers.** A stack with more than 5 layers stops being easier to review. If the diff genuinely needs more, ask the user before proceeding.
- **Each layer must compile and pass the full workspace test suite on its own.** Not just the layer's changed crates, the whole workspace. A layer that only compiles in the presence of a later layer is not a valid layer.
- **Run from the source branch; carve into new branches.** The stack is built as new branches created off `origin/main`. The source branch is never checked out for writes, rewritten, or pushed. Requires a clean working tree.

## Step 0: Preflight

1. Confirm prerequisites: `gh extension list | grep gh-stack` should show the extension, and the bundled `gh-stack` skill must be loadable. If either is missing, stop and surface install steps from the Prerequisites section.
2. If `$ARGUMENTS` is set, read the PR for context only: `gh pr view $ARGUMENTS --json title,body,headRefName,baseRefName,author`. If the PR's head branch doesn't match the current branch (`git branch --show-current`), ask the user whether to proceed using the current branch's content or to check out the PR's branch first.
3. Refuse to proceed if:
   - `git status --short` is non-empty. The working tree must be clean.
   - The current branch is already part of a stack (check `.git/gh-stack` metadata, or invoke the gh-stack skill to inspect).
   - The current branch has unresolved merge conflicts against `main`.
   - The current branch has merge commits relative to `origin/main` (`git log --merges origin/main..HEAD` is non-empty). `gh stack` and `git apply` assume linear history. Ask the user to rebase first.
   - The current branch's diff against `origin/main` is < ~200 lines. Splitting tiny branches is just churn. Tell the user it's not worth splitting.

## Step 1: Capture Source Content

The source of truth is the **current branch's diff against `origin/main`**. This works whether or not the branch has been pushed and whether or not it has an open PR.

1. `git fetch origin main`
2. Derive a short slug:
   - If `$ARGUMENTS` is set, use the PR title (lowercase, hyphens, no special chars). Example: `feat: add session persistence` becomes `session-persistence`.
   - Otherwise, use the current branch name with any `feat/`/`fix/` prefixes stripped.
3. Save the full diff for later carving: `git diff origin/main..HEAD > /tmp/split-pr-<slug>.patch`.
4. Note the current branch name and HEAD sha. The source branch is never modified by this skill. The user can `git checkout <source-branch>` at any time to return to it, and can keep adding commits to it after the stack lands. `/restack-pr` will dispatch them later.

## Step 2: Plan the Split

Read the full diff from the captured patch: `/tmp/split-pr-<slug>.patch`. If it's too large to read in one pass, run `git diff --stat origin/main..HEAD` first, then read per-file diffs for the biggest files.

Produce a **layered split plan** with these properties:

- **Bottom-up dependency order.** Layer 1 has no dependencies on later layers. Layer 2 may depend on layer 1. Etc.
- **Each layer is self-contained.** Compiles + passes tests after that layer is applied, with no later layers present.
- **Each layer has one clear theme.** Examples of good layer themes: "extract X into its own module", "add the Y trait + impl", "wire the Y trait through the host", "add CLI flag and tests". Reject "miscellaneous" layers.
- **Refactors come before features that use them.**
- **Tests for a layer live in the same layer**, not split off into a "tests" layer at the end.

Apply the **Simplicity Rules** (see `/work-issue` Step 3b) to the plan: if a layer feels like premature abstraction or unrequested flexibility, fold it into another layer rather than promoting it. Don't split for the sake of splitting.

Apply the **Duplication Check** (see `/work-issue` Step 3b): if the source branch added a helper that duplicates something already in the repo, flag it as a finding to fix in the appropriate layer instead of preserving the duplication.

### Plan Output

Present the plan to the user as a table and wait for approval before any branches are created:

```
## Split plan for branch <source-branch>

| # | Branch                  | Theme                              | Files / Hunks                | Depends on |
|---|-------------------------|------------------------------------|------------------------------|------------|
| 1 | <slug>/01-refactor-x    | Extract X into its own module      | src/x/**, tests/x_test.rs    | main       |
| 2 | <slug>/02-y-trait       | Add Y trait and impl               | src/y.rs, src/lib.rs         | 1          |
| 3 | <slug>/03-host-wiring   | Wire Y through the host            | src/host.rs, tests/host.rs   | 2          |
| 4 | <slug>/04-cli           | Add --y CLI flag + tests           | src/cli.rs, tests/cli.rs     | 3          |

Each layer compiles and passes the full workspace test suite on its own.
Source branch <source-branch> stays untouched; use /restack-pr to dispatch later changes.
[If $ARGUMENTS is set] PR #$ARGUMENTS will be marked superseded once the stack is up and green.

Proceed? [y/n]
```

If the user requests changes, accept inline edits in a single follow-up turn rather than re-presenting the full plan per tweak. Do not start creating branches until the user explicitly approves.

### Record per-hunk ownership

Once the plan is approved, write a manifest at `.git/gh-stack/<slug>/ownership.json` mapping each hunk (file path + line range) to its target layer. `/restack-pr` reads this manifest as the authoritative ownership source. Without it, restack falls back to file-based ownership, which loses precision whenever a single file straddles layers.

## Step 3: Build the Stack

The source branch is preserved untouched. The stack is built as new branches created off `origin/main`. The user can `git checkout <source-branch>` at any time to return to the original work.

1. Create the first stack branch off `origin/main` without touching the source branch:
   - `git checkout -b <slug>/01-<theme> origin/main`
2. **Initialize the stack via the gh-stack skill.** Ask it to adopt the new branch as the first layer with prefix `<slug>` and numbered branch naming.
3. For **layer 1**:
   - Apply only the hunks belonging to layer 1. Use `git apply --include='<path>'` for file-level scoping, or split the patch into per-hunk patches and apply selectively when hunks within a file straddle layers.
   - If `git apply` rejects a hunk, retry with `git apply --3way`. If that also fails, stop and surface the `.rej` file path + hunk to the user. Do not proceed.
   - Run **Step 4 verification** on the working tree.
   - Only after verification passes, stage and commit with a conventional message: `git commit -m "<type>(<scope>): <layer theme>"`.
4. For **each subsequent layer (2..N)**:
   - Apply the next layer's hunks (same `git apply` / `--3way` / surface-rej flow).
   - Run **Step 4 verification** on the working tree.
   - **Invoke the gh-stack skill to add the next layer** with the layer's commit message; that skill handles branch creation, ordering, and commit in one step.
5. After the last layer, ask the gh-stack skill to **show the stack** and confirm the shape matches the approved plan.

## Step 4: Per-Layer Verification (mandatory before committing each layer)

Run the **full workspace** checks in fail-fast order. Stop on the first failure; do not run later checks. A layer that only passes if a later layer is present is invalid: surface it, drop back to Step 2, re-plan.

**Rust (in order):**
1. `cargo fmt --check`
2. `cargo check --workspace --all-targets`
3. `cargo clippy --workspace --all-targets -- -D warnings`
4. `cargo test --workspace`

**TypeScript (in order):**
1. `pnpm -r exec tsc --noEmit`
2. `pnpm -r test`

**If any check fails on a layer:**
1. Stop. Do not commit the layer.
2. Identify whether the failure means the layer is missing something (move a hunk from a later layer down) or has something that doesn't belong (move a hunk from this layer up).
3. Update the plan, get user re-approval, re-apply the hunks.
4. Re-run Step 4.

## Step 5: Simplify Pass on the Stack

Once all layers are committed locally, invoke the `/simplify` skill on the stack as a whole (each layer's diff). Treat its output as findings:

- If a finding sits inside one layer, fix it in place with `git commit --amend`, or `git commit --fixup=<layer-head-sha>` then ask the gh-stack skill to **restack** the layers above. Do not run `git rebase -i --autosquash` manually.
- If a finding crosses layers (e.g. a helper added in layer 2 duplicates one already in layer 1), fix it in the correct layer and re-run Step 4 on every impacted layer.

## Step 6: Push and Submit

1. **Invoke the gh-stack skill to push every layer's branch.**
2. **Invoke the gh-stack skill to submit the stack.** One PR per layer with linked base branches.
3. For each PR opened, set the body using the **PR summary style** (see `/work-issue` Step 7): big picture for an engineer familiar with the project, ~10 lines max, no play-by-play. Append the AI disclosure line: `_Authored with assistance from Claude Code._`
4. If `$ARGUMENTS` is set, the top-of-stack PR's body should additionally reference the superseded PR: `Supersedes #$ARGUMENTS.`

## Step 7: Block on CI for the Whole Stack

Wait until **every PR in the stack** has all required checks green. Use `gh pr checks <pr-number>` per layer.

Distinguish transient failures (network, infra, timeout, cancelled) from hard fails. Retry transient once via `gh run rerun --failed`. Only diagnose-and-fix on a hard fail or a second consecutive transient.

If a layer hard-fails:

1. Diagnose the failing layer.
2. Fix in place (commit on that layer, then **invoke the gh-stack skill to sync** so upper layers rebase on the fix).
3. **Invoke the gh-stack skill to push** again.
4. Resume waiting.

Do not proceed to Step 8 until every layer is green.

## Step 8: Supersede the Original PR (only if `$ARGUMENTS` was set)

If no PR number was passed, skip this step. There's nothing to supersede. The source branch stays local and the user can keep working from it; `/restack-pr` will dispatch later changes onto the stack.

Otherwise, only after the entire stack is green:

1. Comment on the original PR linking to every layer: `gh pr comment $ARGUMENTS --body "Superseded by stack: #<n1>, #<n2>, ... _Authored with assistance from Claude Code._"`.
2. Close the original PR: `gh pr close $ARGUMENTS`.

The source branch is preserved locally either way. If the user invoked from inside a worktree, leave the worktree as-is. They may want to keep working on the source branch and run `/restack-pr` later.

## Escalation Rules

- **Plan needs more than 5 layers**: ask the user before proceeding.
- **A layer cannot be made self-contained** (compile/tests fail no matter how hunks are split): stop and surface the dependency. The diff may not be cleanly splittable.
- **Hunks within a single file straddle layers in a way `git apply` can't express cleanly**: stop, show the user the conflicting hunk, suggest the layer it most likely belongs to (file-level or theme-level), and ask.
- **`git apply` rejects a hunk and `--3way` also fails**: stop, surface the `.rej` file path and hunk. Do not proceed.
- **The gh-stack skill reports a failure during submit/push/sync** (feature flag, base branch, conflict, etc.): stop and surface the failure verbatim. Do not fall back to manual `gh pr create --base` chaining or raw `git` recovery without explicit user approval.

## Important Rules

- **Never rewrite or push the source branch.** The stack is carved into new branches off `origin/main`.
- **Never submit a stack until every layer passes the full workspace tests locally.**
- **Never close the original PR until the entire stack is green on CI.**
- **Layer themes are mandatory.** Reject "miscellaneous" layers.
- **Disclose AI assistance.** Every PR body in the stack and every PR/issue comment must carry the disclosure line: `_Authored with assistance from Claude Code._`. Commit messages stay clean.
- **Apply the Simplicity Rules and Duplication Check during planning**, not as a post-hoc cleanup.
