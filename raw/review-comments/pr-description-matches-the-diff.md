---
id: pr-description-matches-the-diff
aliases: []
tags:
  - review-comments
  - code-review
  - process
creation date: 2026-09-30 10:17
modification date: Wednesday 7th October 2026 20:42:22
---

## The idea
Reviewers and QA work from the PR description. Whatever it claims gets checked, and whatever it leaves out usually doesn't. Descriptions go stale easily: they get written early, the branch changes, a stacked PR gets split and a hunk moves elsewhere, and the text still claims the old version. Treat the description as something you verify against the diff, not a summary you wrote once.

## Example
Before requesting review:
- Rewrite the description after the last commit, not the first.
- For each claim ("adds X", "fixes Y", "no behavior change"), find the line in the diff that makes it true, and delete claims you can't find.
- List deliberate behavior changes explicitly, especially changes to defaults on shared components, which often show up only as "updated stale test expectations".
- Make the test plan honest ("no new tests" when there are 1,000 lines of tests means reviewers skip them).
- After a late cleanup commit, re-read your own "fixed" replies on review threads. A commit that deletes a refactor makes those replies false, and reviewers treat replied threads as done.
- When review feedback removes or renames a feature (a reviewer asks to drop click-to-filter, rename a column), edit the description and the test plan in the same push. Otherwise QA goes looking for the removed feature and files it as a bug, and the test plan claims coverage for code that no longer exists.
- After merging main, diff against the merge base (`git diff origin/main...HEAD`) and look for lines main deleted that your branch quietly brought back.
- Don't change approach inside a merge commit. Authored changes in a merge (an "evil merge") don't show up when reviewers read commit by commit, and the description written for the first approach silently goes stale. Make the rewrite its own commit and update the description with it.

## Why it matters
An inaccurate description is how bugs get approved: a lost fix is "confirmed" because it's described, and a changed default escapes QA because it isn't. Undocumented intentional changes also get reverted by the next person, who reasonably assumes they were accidental.

## Rule of thumb
Every claim in the description points to a line in the diff, and every behavior change in the diff appears in the description. A changed test expectation on a shared component usually means a changed default, so say so.
