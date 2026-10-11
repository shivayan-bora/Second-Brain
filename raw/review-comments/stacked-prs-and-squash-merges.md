---
id: stacked-prs-and-squash-merges
aliases: []
tags:
  - review-comments
  - git
  - code-review
  - process
creation date: 2026-10-07 20:58
modification date: Wednesday 7th October 2026 20:58:10
---

## The idea
In a stack of pull requests (B is based on A, C on B), two everyday actions quietly change what a reviewer is looking at.

1. **Squash-merging a lower PR into main.** A squash merge lands A's changes as one new commit on main. A's original commits never reach main, so B's branch still contains them, and the merge base of B and main stays where it was. The pull request page shows "everything since the merge base", which now includes all of A's changes again, even though main already has them byte for byte. The diff looks bigger than it is, and things that already shipped (a shared component change, for example) look like part of B.
2. **Merging an upper PR into a lower branch.** If C is merged into B's branch (instead of into main), C shows "Merged" on the hosting site, but its code has only reached B. It goes to main through B's review. If B's description doesn't mention C, nobody reviews C at all.

A third side effect: when a pull request has merge conflicts, many CI setups skip the `pull_request` workflows, because there is no merge commit to test. Only checks that run on the raw head commit report status, which can look like "all green".

## Example
Find the real delta (what would change on main if this merged now) without touching your working tree:

```bash
git fetch origin main <head-sha>
tree=$(git merge-tree --write-tree origin/main <head-sha> | head -1)   # non-zero exit = conflicts, listed below the tree id
git diff --stat origin/main "$tree"                                     # the real change set
git diff origin/main "$tree" -- path/to/file                            # conflicted files show markers here
```

Spot PRs folded into the branch, and check whether anyone reviewed them:

```bash
gh api repos/<org>/<repo>/pulls/<n>/commits --jq '.[].commit.message' | grep '(#'
gh api repos/<org>/<repo>/pulls/<other>/reviews --jq '.[].state'   # empty = never reviewed
```

The usual fix for the inflated diff is to merge main into the branch once: the merge base moves forward, and the already-landed files drop out of the PR.

## Why it matters
Review effort goes to the wrong place: people re-read code that already shipped and misjudge the blast radius, while code that never got a review rides along under another PR's title. Reverting "that PR" later also reverts the folded-in work. And a conflicting PR can sit with no real CI signal for days.

## Rule of thumb
Before reviewing a PR from a stack, do a trial merge against the target to get the real file list, list every PR merged into the branch and check its reviews, and confirm CI actually ran on the head commit. The description should cover everything that reaches the target. See [[pr-description-matches-the-diff]] and [[merge-conflict-after-code-move]].
