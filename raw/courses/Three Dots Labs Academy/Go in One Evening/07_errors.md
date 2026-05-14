---
creation date: 2026-04-22 11:35
modification date: Wednesday 22nd April 2026 11:35:59
tags:
  - chapter
status:
  - in-progress
---

```go

```

```markdown
  ## Summary

  Reduce Karma suite memory pressure and fix spec-ordering fragility exposed by
  running CI batches independently.

  ### Spec fixes — `APP_SETTINGS.featureFlags` seeding (4 specs)
  These specs threw `Cannot read properties of undefined` during setup because
  they relied on another spec loaded earlier in the same Karma run to seed
  `APP_SETTINGS.featureFlags` as a side-effect. They fail deterministically when
  the batch ordering changes. Each now seeds its own feature flags in `beforeEach`
  via the existing `createFeatureFlags()` helper:
  - `src/app/core/test-execution.service.spec.ts`
  - `src/app/reporting/daily-progress-diagram/daily-progress-diagram.component.spec.ts`
  - `src/app/project/project-permissions/project-permissions.component.spec.ts`
  - `src/app/test-management/reorder-testcases/reorder-testcases.component.spec.ts`

  ### Component fixes — `ngOnDestroy` + `_destroyed$` chain (10 components)
  Components extending `BaseComponent` (or a subclass) that overrode
  `ngOnDestroy` without calling `super.ngOnDestroy()`. Missing that call prevents
  `_destroyed$.next()/complete()` from firing, so every
  `takeUntil(this._destroyed$)` subscription in those components leaks for the
  app session.

  **Bucket A** — appended `super.ngOnDestroy()` to trivial side-effect destroys:
  - `shared/components/download/download.component.ts`
  - `shared/sidenav/bind-testcase-automation/bind-testcase-automation.component.ts`
  - `test-management/ai-artifacts/ai-empty-artifacts/ai-generate-artifacts-no-more/ai-generate-artifacts-no-more.component.ts`
  - `test-management/heatmap/sap-analyse-transport-no-license/sap-analyse-transport-no-license.component.ts`

  **Bucket B** — removed redundant manual `.unsubscribe()` calls (each
  subscription already had `takeUntil(this._destroyed$)`), kept legitimate
  cleanup (SignalR `disconnect()`, chart `.destroy()`, DOM `removeEventListener`,
  Subject `.complete()`), added `super.ngOnDestroy()`:
  - `test-management/ai-artifacts/ai-import-artifacts/testcases/ai-import-testcases/ai-import-testcases.component.ts`
  - `test-management/heatmap/heatmap/heatmap.component.ts`
  - `test-management/heatmap/sap-analyse-heatmap-overlay/sap-analyse-heatmap-overlay.component.ts`
  - `test-management/performance-testing/performance-scenario-chart/performance-scenario-chart.component.ts` (also added `takeUntil` to two previously-leaky subs: `themeChanged`, `chartSelectionChanged`)
  - `test-management/requirement/requirement/requirement.component.ts`

  Also deleted a broken `ngOnDestroy` override that was calling `.unsubscribe()`
  on a `Subscription` field that could be `undefined` when `ngOnInit` hadn't run
  (the trigger for the original bug investigation):
  - `test-management/ai-artifacts/ai-inprogress-artifacts/ai-inprogress-artifacts.component.ts`

  ### Karma config — `karma.conf.js`
  - `clearContext: true` (was `clearContext: isCI`). Karma's Jasmine iframe is
    now torn down between runs instead of pinned with the full spec-runner UI.
    Retained DOM across 1800+ specs was a contributor to the ChromeHeadless OOM
    disconnects observed near end-of-batch.
  - Added `processKillTimeout: 10000`. Gives ChromeHeadless time to exit cleanly
    before SIGKILL; eliminates the `ChromeHeadless was not killed in 2000 ms`
    warning at run end.

  ### Docs
  Added guardrails to `Frontend/CLAUDE.md`, `Frontend/AGENTS.md`, and
  `Frontend/src/testing/AGENTS.md` so the two anti-patterns fixed here are
  flagged for future code/spec authors.

  ### Test plan
  - [ ] Run `npm run test:ci:batch{1,2,3,4,5}` locally — expect newly-fixed specs pass regardless of batch ordering
  - [ ] Confirm `ChromeHeadless was not killed in 2000 ms` warning no longer appears in Karma output
  - [ ] Smoke the heatmap + requirement + perf-scenario chart pages locally (Bucket B touched destroy flows)
```
