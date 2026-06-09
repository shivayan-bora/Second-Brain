---
title: "git worktree"
pillar: software-engineering
type: concept
tags: [git, worktree, workflow, tooling]
status: stable
sources: ["[[video-git-worktree-netninja]]"]
created: 2026-06-09
updated: 2026-06-09
---

# git worktree

## Definition

A **git worktree** is a folder with a checked-out branch from a repository. A repository has at least one worktree (the default one created at `git clone`); `git worktree add` creates additional ones that share the same `.git` directory — and therefore the same history, commits, remotes, and hooks.

## Why it matters

Worktrees turn "switching branches" from a directory-state operation into a directory-*selection* operation. You stop stashing/committing-WIP just to peek at another branch, and you can run long-running tasks (tests, builds, dev servers) on multiple branches simultaneously. The pattern shines when you're juggling parallel streams — feature work + a hotfix, or multiple agent sessions on the same repo.

## Mechanics

### Layout (recommended)

```
my-project/
├── .git/              ← bare clone here
├── main/              ← first worktree, on `main`
├── feature-x/         ← second worktree, on `feature-x`
└── feature-y/         ← third worktree
```

### Setup

```bash
# Bare clone into .git/, giving a directory dedicated to worktrees
mkdir my-project && cd my-project
git clone <url> --bare .git

# Add a main worktree
git worktree add main
```

### Add a worktree for a new branch

```bash
git worktree add -b feature-x ../feature-x origin/main
```

- `-b <name>` creates the branch.
- The path can be relative or absolute. Convention: sibling directories.
- The starting commit defaults to `HEAD`; the explicit `origin/main` makes it independent of which worktree you're currently in.

### Inspect and clean up

```bash
git worktree list                    # which branch lives where
git worktree remove ../feature-x     # delete worktree (refuses if dirty)
git worktree remove -f ../feature-x  # force; drops uncommitted changes
```

## Rules and constraints

- **Cannot check out the same branch in two worktrees.** Git tracks the binding; an attempt to add the same branch elsewhere fails fast.
- **Cannot delete the main worktree.** Protected.
- **One `.git` directory shared across all worktrees.** A single `git fetch` updates remotes for all; hooks in `.git/hooks` run regardless of which worktree triggered them.
- **`git worktree list` is the source of truth** — worktrees won't appear in `git branch -a` differently from non-worktree branches.

## What it isn't

- Not a fork — same repo, same history.
- Not a stash — branches are real, can be committed, pushed, fetched.
- Not a submodule — no nesting; just additional working directories.

## Examples

```bash
# I'm working on feature-x. A code review request lands for main.
cd ../main
git pull
# review, comment, fix in place, push
cd ../feature-x
# back to my feature, no stash dance
```

```bash
# Run tests on main while developing feature-x:
(cd ../main && npm test &)  # backgrounded
cd ../feature-x
# code
```

## Trade-offs

- **Pro:** zero context loss when switching streams.
- **Pro:** dev servers and test runners on multiple branches don't fight.
- **Pro:** AI agents can work on separate branches in parallel without colliding.
- **Con:** the bare-clone layout is unfamiliar; tools that assume `cwd/.git` work fine; tools that hardcode `cwd` paths may not.
- **Con:** discipline required — orphan worktree directories accumulate if you don't `worktree remove`.

## Related

- [[parallel-development-with-worktrees]] — the pattern that uses worktrees as a primitive.

## Sources

- [[video-git-worktree-netninja]]
