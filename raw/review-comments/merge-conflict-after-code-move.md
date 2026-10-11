---
id: merge-conflict-after-code-move
aliases:
  - extracted code loses upstream edits
tags:
  - review-comments
  - git
  - refactoring
creation date: 2026-10-01 12:57
modification date: Friday 9th October 2026 15:46:25
---

## The idea
git merges by location, not by meaning. Suppose your branch moves a block of code from `a.tsx` into a new file `b.tsx`, and meanwhile the main branch edits that same block in `a.tsx`. git reports a conflict only in `a.tsx`: you deleted the lines, they changed them. `b.tsx` is a brand new file that nobody else touched, so it merges cleanly and still holds the old version of the code. The obvious way to resolve the conflict ("I removed this on purpose, keep my side") throws away the upstream change, and nothing flags it anywhere.

The opposite direction bites too. If the target branch moved `a.tsx` to `shared/b.tsx` while your branch edited `a.tsx`, git's rename detection carries your edit into `shared/b.tsx`, often with no conflict at all. If the move also turned the file into a shared component, your local tweak now changes every other importer, and nobody reviewed it for them.

## Example
```
merge base:  a.tsx  -> renderOwners() { owners.map(o => <OldLink o={o} />) }
your branch: a.tsx  -> <OwnersList />          (block removed)
             b.tsx  -> OwnersList() { owners.map(o => <OldLink o={o} />) }   (copied)
main:        a.tsx  -> renderOwners() { assignedOwners.map(o => <NewLink o={o} /><Reasons o={o} />) }

merge result: CONFLICT in a.tsx, b.tsx merges cleanly with the OLD code
resolve a.tsx with "ours" -> main's NewLink + Reasons are gone
```
How to catch it before resolving:
```sh
git log --oneline $(git merge-base HEAD origin/main)..origin/main -- a.tsx
git diff $(git merge-base HEAD origin/main) origin/main -- a.tsx   # what you must port into b.tsx
```
The opposite direction, upstream moved the file you edited:
```sh
git merge-tree --write-tree --name-only origin/main HEAD   # trial merge, lists conflicts and renamed paths
git grep -l "shared/b" origin/main                       # every importer your edit now reaches
```

## Why it matters
Extract-component refactors are common in long-lived branches, especially when a big change is split into stacked PRs. The type checker helps only if upstream renamed or removed something the stale copy still uses. If upstream only added behavior, like a new button or a new branch, the stale copy still compiles and the feature quietly disappears. Tests can catch it only if you also bring upstream's new tests along, and those usually live next to the old file.

## Rule of thumb
When a branch moved code, treat every conflict at the old location as "port upstream's change into the new location". Don't treat it as "keep my deletion". Diff the old path on the target branch since the merge base, apply those edits to the new file, and rerun upstream's tests against it. Also consider [[git rebase]] early and often on branches that move code, so the window for this kind of drift stays small. When upstream moved a file you edited, a clean merge is not the end of the check: list the new location's importers and look at each one, because your change now reaches all of them.
