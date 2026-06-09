---
title: "Parallel Development with git worktrees"
pillar: software-engineering
type: pattern
tags: [git, workflow, worktree, productivity]
status: stable
sources: ["[[video-git-worktree-netninja]]"]
created: 2026-06-09
updated: 2026-06-09
---

# Parallel Development with git worktrees

## Context

You're working on multiple streams of work that touch the same repository — feature work plus a hotfix, a PR review interrupting in-progress code, multiple AI agents on related branches, or simply wanting to run dev servers and test suites on different branches at the same time.

The default git workflow assumes one working directory per repo: switching branches requires committing or stashing in-progress changes, plus the IDE re-indexing the world. This penalty makes context-switching expensive enough that developers avoid it, batching unrelated work into single branches.

## Problem

Single-working-directory workflows force a trade between:
- Committing or stashing WIP work just to peek at another branch (and the cleanup cost when you come back),
- Living with a polluted branch where unrelated changes accumulate, or
- Cloning the repo multiple times into separate paths (duplicating `.git`, fighting with remote synchronization).

None of these are great. The cost compounds when you're running long-lived processes (dev server, watcher, test suite) that are tied to a checked-out branch.

## Solution

Use **`git worktree`** to give each parallel stream of work its own working directory, all sharing one `.git`.

### Recommended layout

```
my-project/
├── .git/              ← bare clone here
├── main/              ← worktree on main
├── feature-x/         ← worktree on feature-x
└── hotfix-prod/       ← worktree on hotfix-prod
```

### Setup once per repo

```bash
mkdir my-project && cd my-project
git clone <url> --bare .git
git worktree add main
```

### Workflow

```bash
# Start new feature
git worktree add -b feature-x ../feature-x origin/main
cd ../feature-x
# code, commit, push

# Hotfix interrupts? new worktree
git worktree add -b hotfix-prod ../hotfix-prod origin/main
cd ../hotfix-prod
# code, commit, push, PR

# Back to feature
cd ../feature-x
# state preserved, no stash dance

# Cleanup
git worktree remove ../hotfix-prod
```

See [[git-worktree]] for the command surface and constraints.

## Trade-offs

### Pros
- **Zero context-switch cost.** No stash, no WIP commit, no re-indexing.
- **Parallel processes survive.** Dev servers, watchers, agents on different branches don't conflict.
- **One source of truth.** `.git` is shared — one `git fetch` updates all worktrees.
- **AI-agent friendly.** Multiple Claude/Cursor sessions can work on separate branches without colliding on the working tree.
- **Code review without disruption.** Pull down a colleague's branch in its own worktree, review, comment, and your in-progress code is untouched.

### Cons
- **Disk usage.** Each worktree carries its own working copy (but not `.git`). A 1GB repo with three worktrees is ~3GB of source files, not 4GB.
- **Tool compatibility.** Tools that hardcode "cwd is the repo root" mostly work; tools that assume `cwd/.git` is a regular `.git` directory may stumble (rare in 2026).
- **Discipline.** Orphan worktree directories accumulate if you don't `worktree remove`. `git worktree list` is your friend.
- **Same branch cannot be checked out twice.** Usually fine, occasionally annoying when you want two views of one branch.
- **One hooks directory.** `.git/hooks` is shared — pre-commit hooks run regardless of which worktree triggered them.

### When to skip the pattern

- Single-stream solo work with no interruptions — the setup cost outweighs the benefit.
- Repos with very large working trees where 3-4× the file count is genuinely costly.
- Tools that can't handle worktree layouts (verify your IDE / CI / scripts).

## Examples

**Pattern variant — long-lived "main" worktree, short-lived per-task worktrees:**

```bash
git worktree add -b task/PROJ-123-fix-login ../PROJ-123 origin/main
cd ../PROJ-123
# ...
git push -u origin task/PROJ-123-fix-login
# PR merges; cleanup:
cd ../main && git pull
git worktree remove ../PROJ-123
git branch -d task/PROJ-123-fix-login
```

**Pattern variant — AI agent isolation:**

Spin up one worktree per agent session. Agent 1 in `worktree-a/`, Agent 2 in `worktree-b/`, both editing concurrently with no merge conflicts. Merge their work via PR when ready.

## Related

- [[git-worktree]] — the primitive this pattern is built on.

## Sources

- [[video-git-worktree-netninja]]
