---
id: ci-drift-checks-for-generated-files
aliases: []
tags:
  - review-comments
  - ci
  - tooling
creation date: 2026-09-30 10:17
modification date: Wednesday 30th September 2026 10:17:27
---

## The idea
Generated or tool-normalized files (codegen output, extracted i18n messages, mocks, optimized SVGs, lockfiles) drift when someone forgets to rerun the tool. The reliable check is to **run the real tool in CI and fail if the working tree changed**. Don't re-implement the tool's logic in a lint or bot rule, because a second implementation misses cases (a config change that makes every file stale), and a warn-only rule lets drift merge anyway.

## Example
```yaml
- run: pnpm codegen && git diff --exit-code
- run: pnpm svg:optimize && git diff --exit-code -- '*.svg'

# Or, catching untracked output too
- run: pnpm messages:extract && test -z "$(git status --porcelain)"
```
If you need a "would the tool change this?" check that runs locally, compare in memory and don't touch the working copy:
```ts
const optimized = execSync(`svgo -i ${file} -o -`).toString()
const isStale = optimized !== readFileSync(file, 'utf8')
```

## Why it matters
Drift punishes the next person who runs the tool: their PR fills up with unrelated churn. Checks that mutate files in place can rewrite a developer's work when run locally, and a guard that turns itself off when a regex fails to match (a different flag spelling, a trailing slash) is worse than none, because everyone thinks they're covered.

## Rule of thumb
Regenerate and diff, fail on drift, and fail closed. A check should be a [[Pure Functions|pure function]] of its inputs, never mutate-then-diff.
