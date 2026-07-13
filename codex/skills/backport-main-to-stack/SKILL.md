---
name: backport-main-to-stack
description: Commit changes on a main/source PR branch and backport, dispatch, or restack those changes onto an existing stacked PR chain. Use when Codex needs to update the issue-96 Rust core source PR `worktree-issue-96-rust-core-port` / PR #104 and propagate the resulting delta onto the `rust-core/*` stack PRs, or for similar source-branch-to-stack workflows.
---

# Backport Main To Stack

## Ground Rules

Treat the source PR branch as canonical and the stack as derived.

- Source PR: `worktree-issue-96-rust-core-port`, GitHub PR #104, base `main`.
- Stack PRs: open `rust-core/*` branches derived from the source branch.
- Use the `gh-stack` skill before any `gh stack` operation.
- Never infer stack order from branch numbers. Discover order from GitHub PR `headRefName -> baseRefName` links.
- Do not start stack mutation until the user approves the hunk-to-layer dispatch plan.
- Propagate lower-layer updates upward with merges, not rebases. The normal outcome must be fast-forward pushes for every stack branch.
- Do not run `git rebase` or `gh stack sync` on stack branches unless the user explicitly overrides this merge-only rule.
- Stop on dirty unrelated work, remote/local divergence, rejected patches, merge conflicts, plain-push rejection, or failing verification.
- The remote top stack branch must end with the exact same git tree as the remote source PR branch. Treat any non-empty diff or tree-hash mismatch as a blocker, not a successful backport.
- Never force push any branch, source PR or stack layer during normal use of this skill. Always `git fetch origin <branch>` first and require local work to be a descendant of `origin/<branch>` before pushing. If a push is rejected as non-fast-forward, stop and report the merge-only invariant failed; do not force push unless the user explicitly overrides the skill.

## Preflight

1. Record the starting branch and working tree state.
2. If uncommitted changes exist and the user asked to commit them on the source PR, stay on `worktree-issue-96-rust-core-port`, stage intentionally, and commit before switching branches. Otherwise stop and ask.
3. Run `git fetch origin main worktree-issue-96-rust-core-port`.
4. Confirm PR #104 still has `headRefName=worktree-issue-96-rust-core-port` and `baseRefName=main`:
   ```sh
   gh pr view 104 --json number,title,headRefName,baseRefName,url
   ```
5. Confirm `gh-stack` is installed with `gh extension list | rg 'gh-stack|github/gh-stack'`. If missing, stop with install instructions.

## Discover The Stack

Use GitHub PR metadata as the source of truth:

```sh
gh pr list --state open --json number,title,headRefName,baseRefName,url \
  | jq -r '.[] | select(.headRefName|startswith("rust-core/")) | "\(.headRefName) \(.baseRefName) #\(.number) \(.title)"'
```

Build the chain from the branch whose base is `main` to the branch that is not used as any other open PR's base. Fetch every layer:

```sh
git fetch origin <layer-branch>
```

The expected issue-96 chain observed when this skill was written is:

```text
rust-core/01-truapi-testing-api
rust-core/02-platform-traits
rust-core/04-codegen
rust-core/04a-server-host-logic
rust-core/04b-server-wire-chain
rust-core/03-server-runtime
rust-core/05-host-wasm
rust-core/06-docs-ci-tooling
```

If GitHub reports a different valid chain, use the GitHub chain and mention the difference. If the chain is forked, missing, or cyclic, stop and ask the user which stack to target.

## Commit On The Source PR

1. Check out `worktree-issue-96-rust-core-port` if not already there.
2. Stage only the intended source-PR changes with `git add` or `git add -p`.
3. Commit using the style that fits the existing source branch, usually either:
   - a conventional commit for a new logical change;
   - `fixup! feat: port Rust core runtime` when the change is intended to fold into PR #104.
4. Run the relevant local verification for the touched area before pushing.
5. Push the source branch:
   ```sh
   git push origin worktree-issue-96-rust-core-port
   ```

## Plan The Backport

1. Compute the delta from stack top to source branch:
   ```sh
   git diff <stack-top-branch>..worktree-issue-96-rust-core-port
   ```
2. If the delta is empty, report that the stack top already matches the source branch and stop.
3. Assign each hunk to the lowest stack layer that owns the behavior:
   - Use existing layer diffs against each layer's base to infer ownership for touched files.
   - Put shared API, types, and primitives in the lowest layer that needs them.
   - Put consumers, integration tests, docs, and tooling in higher layers where they belong.
   - If a hunk straddles layers, suggest the most coherent layer and ask the user.
4. Present a concise dispatch plan before mutation:
   ```text
   Source: worktree-issue-96-rust-core-port
   Stack top: <stack-top-branch>
   Delta: <N> files, <N> hunks

   Hunk dispatch:
   - <file>: <target-layer> (<reason>)

   Impacted layers:
   - <target-layer>
   - every layer above it
   ```
5. Wait for explicit user approval.

## Apply Bottom-Up

For each target layer, from lowest to highest:

1. Check out the layer. Prefer `gh stack checkout <branch>` through the `gh-stack` skill when possible; otherwise use `git checkout <branch>` only after confirming it is the intended local layer branch.
2. Apply only the approved hunks for that layer. Prefer a temporary per-layer patch and use `git apply --3way` if plain apply fails.
3. Run verification appropriate to that layer:
   - Rust: `cargo fmt --check`, `cargo check --workspace --all-targets`, targeted tests, then broader tests when risk warrants.
   - TypeScript: `pnpm -r exec tsc --noEmit`, targeted tests, then broader tests when risk warrants.
4. Commit the layer with a conventional message or an appropriate `fixup!` message matching that layer's PR.
5. Merge the updated layer into each upper layer, one branch at a time, in stack order:
   ```sh
   git checkout <child-branch>
   git fetch origin <child-branch>
   git merge --no-ff <updated-parent-branch>
   ```
   Resolve conflicts by preserving the approved lower-layer content and the child's own layer content. Run that child layer's relevant verification after each merge. Commit the merge normally; do not squash it.
6. Repeat for the next target layer after the whole upper stack contains the current parent.

After all impacted layers pass locally, push each changed stack branch with a plain fast-forward push:

```sh
git fetch origin <branch>
git merge-base --is-ancestor origin/<branch> <branch>
git push origin <branch>
```

If `merge-base --is-ancestor` fails or `git push` is rejected, stop. Do not switch to `--force-with-lease`; inspect whether a remote update must first be merged or whether the user wants to override the merge-only workflow.

Then verify the pushed remote top stack branch exactly matches the pushed remote source PR branch:

```sh
git fetch origin worktree-issue-96-rust-core-port <stack-top-branch>
git diff --quiet --submodule=log origin/<stack-top-branch>..origin/worktree-issue-96-rust-core-port
test "$(git rev-parse origin/<stack-top-branch>^{tree})" = "$(git rev-parse origin/worktree-issue-96-rust-core-port^{tree})"
```

If either command fails, stop, inspect the remaining diff, fix the stack, push again, and repeat this remote comparison before reporting success.

## Finish

1. Check each impacted PR status with `gh pr checks <pr-number>` when requested or when the push changed CI-relevant code.
2. Report the remote tree comparison result, including both tree hashes. The hashes must be equal.
3. Return to `worktree-issue-96-rust-core-port`.
4. Report:
   - source branch commit pushed;
   - stack layers changed and pushed;
   - top stack tree equals source PR tree;
   - tests run;
   - CI status or checks not waited for.
