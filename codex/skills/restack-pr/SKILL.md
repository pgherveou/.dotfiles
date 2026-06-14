---
name: restack-pr
description: Dispatch new changes from your source branch onto the gh-stack stack derived from it. Each impacted layer is rebased, runs the full workspace test suite, and CI is awaited before the restack is considered done. Use after `/split-pr` when you've made more changes on the source branch and want them routed to the right layer.
argument-hint: "[optional: stack-pr-number]"
disable-model-invocation: false
---

# Restack From Source Branch

Dispatch new changes from the **source branch** (the branch you're on when invoking this skill) onto the existing stack that was derived from it. The source branch is the source of truth; the stack is a derived artifact that gets updated to match.

`$ARGUMENTS` is optional. Pass any PR number from the stack to disambiguate when multiple stacks exist in the repo. Omit it to let the skill identify the stack from local `.git/gh-stack` metadata.

## Prerequisites

`gh stack` mechanics run through the bundled `gh-stack` skill (vendored from [github/gh-stack](https://github.com/github/gh-stack); see `skills/gh-stack/NOTICE.md`). For any `gh stack` operation, invoke the `gh-stack` skill. Do not call `gh stack` directly.

Required setup (one-time):

```sh
gh extension install github/gh-stack
```

A stack must already exist for this repo (use `/split-pr` first if it doesn't).

If the extension is missing, the `gh-stack` skill is not loadable, or a local stack is missing, stop on Step 0 and surface install steps.

## Defaults

- **Source branch = source of truth.** Run this skill from the branch holding the latest work; the stack is updated to match. The source branch is never modified.
- **Operate in place.** No new worktree is created. Requires a clean working tree.
- **Impacted layers = touched layer + every layer above it.** Rebasing changes upper layers, so they all need re-verification.
- **Full workspace tests per impacted layer.** Not just changed crates.
- **Block on CI for every impacted PR.** The command returns only after every impacted PR is green.

## Step 0: Preflight

1. Confirm prerequisites: `gh extension list | grep gh-stack` should show the extension, and the bundled `gh-stack` skill must be loadable. If either is missing, stop and surface install steps from the Prerequisites section.
2. Record the **source branch**: `git branch --show-current`. This is where the new changes live and where the user keeps working. The skill returns the user to this branch at the end.
3. Locate the stack:
   - If `$ARGUMENTS` is set, treat it as any PR in the stack: `gh pr view $ARGUMENTS --json headRefName -q .headRefName` is a layer branch. `git fetch origin <layer-branch>` then `git checkout <layer-branch>` and **invoke the gh-stack skill to view the stack** to confirm.
   - Otherwise, read `.git/gh-stack` to find the stack rooted off this repo (or ask the gh-stack skill to list local stacks). If there are multiple, ask the user which one. If there are none, stop and tell the user to run `/split-pr` first.
4. `git fetch origin` for every layer branch in the stack. If any local layer branch is behind its remote, stop and ask the user to pull/reconcile before dispatching. A force-push during restack would clobber a teammate's commits.
5. Refuse to proceed if:
   - `git status --short` is non-empty on the source branch.
   - The source branch has merge commits relative to `origin/main` (`git log --merges origin/main..HEAD` is non-empty). Linear history is required. Ask the user to rebase first.
   - The stack has uncommitted local edits on any layer the user hasn't acknowledged.
   - There are open conflicts on any layer against its base.

## Step 1: Compute the Delta

The delta is everything on the source branch that isn't already on the stack's top.

1. `git fetch origin main`
2. **Invoke the gh-stack skill to identify the stack-top branch** (the branch furthest from trunk).
3. `git diff <stack-top-branch>..<source-branch>` is the set of hunks that need dispatching.
4. If the delta is empty, stop and tell the user there's nothing to restack.
5. If the delta's line count is >= the sum of lines across all existing stack layers, suggest the user run `/split-pr` instead. The source branch has drifted far enough that re-splitting is cleaner than re-dispatching.

Save the delta as a patch file: `git diff <stack-top-branch>..<source-branch> > /tmp/restack-<slug>.patch`.

## Step 2: Plan the Dispatch

For each hunk in the delta, decide which layer owns it.

**Authoritative source: per-hunk ownership manifest.** If `.git/gh-stack/<slug>/ownership.json` exists (written by `/split-pr`), use it as the primary source. It maps file path + line range to layer.

**Fallback: file-based ownership.** If the manifest is missing, a hunk's target layer is the lowest layer whose diff touched any of the same files. New files default to the topmost touched layer (the feature's "home"), shown as a suggestion the user can override.

**Straddling hunks:** If a single hunk modifies regions that, by either ownership rule, belong to two different layers, escalate. **Always suggest the most sensible target** (usually the lower layer, since refactors belong below features) and let the user accept or override.

**Impacted layers:** target layer + every layer above it.

### Plan Output

Present the dispatch plan to the user as a table and wait for approval:

```
## Restack plan

Source branch: <source-branch>
Delta: <N> hunks across <M> files

### Hunk dispatch
| Hunk | File                         | Target layer            | Notes                       |
|------|------------------------------|-------------------------|------------------------------|
| 1    | src/x/parser.rs              | <slug>/01-refactor-x    | clean fit                    |
| 2    | src/y.rs                     | <slug>/02-y-trait       | clean fit                    |
| 3    | src/host.rs (lines 40-80)    | <slug>/03-host-wiring   | clean fit                    |
| 4    | src/cli.rs + src/x/parser.rs | **straddles 01 and 04** | **suggested: 01** (refactor) |

### Impacted layers (will be rebased + re-verified)
- <slug>/01-refactor-x: tests + CI
- <slug>/02-y-trait: tests + CI (rebased)
- <slug>/03-host-wiring: tests + CI (rebased)
- <slug>/04-cli: tests + CI (rebased)

Proceed? [y/n]
```

If the user overrides any suggested target, accept the override inline. Do not start dispatching until explicit approval.

## Step 3: Dispatch, Bottom-Up

For each impacted layer, from bottom to top of the stack:

1. **Invoke the gh-stack skill to navigate to that layer** (it handles `gh stack down`/checkout).
2. Apply the hunks targeting that layer (`git apply <per-hunk-patch>`). If `git apply` rejects, retry with `git apply --3way`. If that also fails, stop and surface the `.rej` file path + hunk to the user. Do not proceed.
3. Run **Step 4 verification** on the working tree.
4. Only after verification passes, stage and commit with a conventional message: `git commit -m "<type>(<scope>): <one-line summary>"`. Prefer one commit per logical change, not one giant commit.
5. **Invoke the gh-stack skill to sync** so every layer above this one rebases on the updated layer. If the gh-stack skill reports conflicts, stop, surface the conflicting layer + path, and ask the user how to resolve. Do not auto-resolve.
6. Continue to the next impacted layer.

**If verification fails on a layer:** stop. Surface the failing layer, the failing command output, and the diff that was just applied. Do not continue dispatching. Do not auto-fix across layers.

## Step 4: Per-Layer Verification (full workspace, fail-fast)

After applying hunks to a layer (and after the gh-stack skill rebases a layer on a lower-layer change via sync), run the **full workspace** checks on the working tree in fail-fast order. Stop on the first failure.

**Rust (in order):**
1. `cargo fmt --check`
2. `cargo check --workspace --all-targets`
3. `cargo clippy --workspace --all-targets -- -D warnings`
4. `cargo test --workspace`

**TypeScript (in order):**
1. `pnpm -r exec tsc --noEmit`
2. `pnpm -r test`

A layer must pass on its own. If it doesn't, the dispatch is wrong (a hunk is in the wrong layer, or a hunk is missing from a lower layer). Stop and re-plan.

## Step 5: Simplify Pass on the Dispatched Changes

Once every impacted layer passes Step 4 locally, invoke the `/simplify` skill on the cumulative dispatched diff (the set of new hunks across all layers). Treat its output as findings:

- If a finding sits inside one layer, fix in place with `git commit --amend`, or `git commit --fixup=<layer-head-sha>` then ask the gh-stack skill to **restack** the layers above. Do not run `git rebase -i --autosquash` manually.
- If a finding crosses layers (e.g. duplicated helper), fix in the correct layer and re-run Step 4 on every layer at or above the fix.

Apply the **Duplication Check** (see `/work-issue` Step 3b): any new helper introduced in this dispatch must `grep` clean against the rest of the repo. Reuse existing helpers when present. Do not silently introduce new third-party dependencies; ask the user.

## Step 6: Push

Once every impacted layer is green locally and the simplify pass is clean:

1. **Invoke the gh-stack skill to push every impacted layer's branch** (it handles `--force-with-lease` correctly).
2. For each impacted PR, update its body if the change materially affects the layer's summary. Apply the **PR summary style** (see `/work-issue` Step 7). Keep the AI disclosure line: `_Authored with assistance from Claude Code._`

## Step 7: Block on CI for All Impacted PRs

Wait until **every impacted PR** has all required checks green. Use `gh pr checks <pr-number>` per impacted layer. This step is blocking. Do not return until all are green or one has hard-failed.

Distinguish transient failures (network, infra, timeout, cancelled) from hard fails. Retry transient once via `gh run rerun --failed`. Only diagnose-and-fix on a hard fail or a second consecutive transient.

**If any impacted PR hard-fails CI:**
1. Diagnose the failing layer.
2. **Invoke the gh-stack skill to navigate** to that layer, fix, then **invoke the gh-stack skill to sync** so the layers above pick up the fix. Run Step 4 on every layer at or above the fix.
3. **Invoke the gh-stack skill to push** again.
4. Resume blocking on CI.

## Step 8: Return to Source Branch and Report

When all impacted PRs are green:

1. Verify `git status --short` is clean on the current layer. If not, stop and surface.
2. `git checkout <source-branch>` so the user is back where they started and can keep working.
3. Report:

```
## Restack complete

| Layer | PR  | Status |
|-------|-----|--------|
| 01    | #N1 | green |
| 02    | #N2 | green (rebased) |
| 03    | #N3 | green (rebased) |
| 04    | #N4 | green (rebased) |

Source branch <source-branch> @ <sha> is now reflected across the stack.
You're back on <source-branch>; keep working and re-run /restack-pr to dispatch later changes.
```

## Escalation Rules

- **Delta is huge** (>= sum of all stack layer line counts): suggest `/split-pr` instead.
- **Hunk straddles layers**: suggest the most sensible target (refactors below, features above) and ask. Never silently pick.
- **`git apply` rejects a hunk and `--3way` also fails**: stop, surface the `.rej` file path and hunk.
- **The gh-stack skill reports conflicts during sync**: stop. Show the conflicting layer and path verbatim. Do not auto-resolve.
- **Verification fails on a layer**: stop. Do not auto-fix across layers. Surface the failing layer and diff.
- **CI hard-fails on an impacted PR after push**: fix in place, propagate, re-verify, re-push, resume blocking on CI.
- **Local layer branch is behind its remote**: stop and ask the user to pull/reconcile before dispatching.

## Important Rules

- **Source branch is the source of truth.** Never modify it from this skill; only read from it. Return to it at the end so the user can keep working.
- **Bottom-up dispatch.** Always dispatch the lowest impacted layer first, then sync upward, then move to the next.
- **Full workspace tests per impacted layer.** Not just changed crates.
- **Block on CI.** The command returns only after every impacted PR is green or one has hard-failed.
- **No auto-fixing across layers.** If a layer fails verification, stop and surface; do not modify other layers to make it pass.
- **No new third-party dependencies without explicit user approval.** The Duplication Check applies.
- **Disclose AI assistance.** PR body updates and PR comments must carry `_Authored with assistance from Claude Code._`. Commit messages stay clean.
