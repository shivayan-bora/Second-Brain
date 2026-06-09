---
title: "Video — Git Worktree (Net Ninja)"
pillar: software-engineering
type: summary
tags: [video, git, worktree, workflow, tooling]
status: stable
source: "raw/videos/Git Worktree - NetNinja.md"
created: 2026-06-09
updated: 2026-06-09
---

# Video — Git Worktree (Net Ninja)

Net Ninja's `git worktree` walkthrough. Establishes both the *concept* (multiple checked-out working directories sharing one `.git`) and the *recommended layout* (bare clone into `.git/`, named per-branch directories as siblings).

## TL;DR

- A **[[git-worktree|worktree]]** is a folder with a checked-out branch. The default `git clone` gives you one; `git worktree add` gives you another, **without duplicating the repository's data**.
- All worktrees share the same `.git` directory — same commits, same remotes, same history. `git fetch` from any worktree updates them all.
- **You can't check out the same branch in two worktrees.** Git enforces this — branches are 1:1 with worktrees while checked out.
- The recommended layout uses a **bare clone into `.git/`** in a parent dir, then `git worktree add main` / `git worktree add -b feature-x feature-x origin/main` as siblings.
- Branch switching becomes a `cd` instead of a stash-and-checkout. See [[parallel-development-with-worktrees]] for the pattern.

## Key takeaways

- The killer use case: **you're in the middle of a feature when a hotfix or code review request comes in**. With worktrees, switch directories — no stash, no commit-WIP, no merge-conflict roulette when you switch back.
- The bare-clone-into-`.git/` trick keeps the parent directory's *file tree* exclusively worktrees, with no "main" working copy mixed in. Mental model: the parent dir *is* the repo; each child dir *is* a branch.
- `git worktree remove <path>` cleans up; `-f` force-removes worktrees with uncommitted changes (with warning that those changes are lost).
- Worktrees don't show up in `git branch -a`; use **`git worktree list`** to see which branches are pinned to which directories.

## The command surface

```bash
# Layout setup
mkdir my-repo && cd my-repo
git clone <url> --bare .git
git worktree add main

# Working on a feature alongside main
git worktree add -b feature-x ../feature-x origin/main

# Inspect
git worktree list

# Cleanup
git worktree remove ../feature-x
git worktree remove -f ../feature-x   # force, drops uncommitted
```

## Notable passages

> "Each worktree still shares the same Git history, the same commits and the same remotes... a single fetch from any worktree updates everything."

> "Git stops you from checking out the same branch twice within those different worktrees."

## Open questions

- How do worktrees interact with `git hooks`? (Hooks are in `.git/hooks` — one set shared across all worktrees.)
- How do worktrees interact with IDE workspaces that index the `.git` directory differently?
- What's the right cleanup hygiene — should worktrees be ephemeral (one per task), or longer-lived (one per long-running stream of work)?
- Does AI coding tools (Cursor, Claude Code, etc.) have first-class worktree support? The pattern seems made for parallel agent work.

## Cross-references

- Concepts: [[git-worktree]].
- Patterns: [[parallel-development-with-worktrees]].

## Source

- `raw/videos/Git Worktree - NetNinja.md`
