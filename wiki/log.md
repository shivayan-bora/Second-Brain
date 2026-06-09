---
title: Wiki Log
type: log
updated: 2026-06-09
---

# Log

Append-only chronological record of ingests, queries, and lint passes.

Entry prefix format: `## [YYYY-MM-DD] {kind} | {short title}` — keeps the log greppable.

## [2026-05-17] init | Wiki scaffolded

- Created [[CLAUDE]] schema at repo root
- Initialized `wiki/` subdirectory tree (software-engineering, leadership, soft-skills)
- Created `wiki/index.md`, `wiki/log.md`, `wiki/synthesis.md`

## [2026-05-17] ingest | Learning Go ch00 — Setting up your Go environment

- Source: `raw/books/Learning Go/00_Setting up your go environment.md`
- Pillar: software-engineering
- Created summary: [[learning-go-ch00-environment-setup]]
- New concept pages: [[go-modules]], [[go-toolchain]], [[makefiles]]
- Touched: `wiki/index.md`
- Open questions logged: `go mod tidy` internals; modern `make` alternatives (`just`, `task`, `mage`)

## [2026-05-17] ingest | Three Dots Labs *Go in One Evening* ch00-07 + Tour of Go: Packages

- Pillar: software-engineering
- 9 summaries created: [[three-dots-labs-go-00-hello]], [[three-dots-labs-go-01-variables]], [[three-dots-labs-go-02-functions]], [[three-dots-labs-go-03-http-server]], [[three-dots-labs-go-04-arrays]], [[three-dots-labs-go-05-slices]], [[three-dots-labs-go-06-conditionals]], [[three-dots-labs-go-07-errors]], [[tour-of-go-00-packages]]
- 8 new concepts: [[go-packages]], [[go-variables]], [[go-functions]], [[go-http-server]], [[go-arrays]], [[go-slices]], [[go-conditionals]], [[go-error-handling]]
- Reused: [[go-modules]], [[go-toolchain]]
- **Flag:** `raw/courses/Three Dots Labs Academy/Go in One Evening/07_errors.md` contains leftover clipboard content (unrelated Karma/Angular PR), not Go error-handling notes. The summary and concept were created as placeholder pages with `status: in-progress`. Re-ingest needed once the user fills in the raw source.

## [2026-05-17] ingest | Epic React Fundamentals 00-04 + react.dev Quick Start + react.gg Big Picture

- Pillar: software-engineering
- 7 summaries created: [[epic-react-rf-00-hello-world-js]], [[epic-react-rf-01-raw-react-apis]], [[epic-react-rf-02-using-jsx]], [[epic-react-rf-03-custom-components]], [[epic-react-rf-04-typescript]], [[react-dev-00-quick-start]], [[react-gg-00-big-picture]]
- 10 new concepts: [[dom-create-element]], [[react-element-vs-component]], [[react-create-element]], [[react-create-root]], [[react-jsx]], [[react-components]], [[react-props]], [[react-fragments]], [[react-hooks]], [[react-typescript]]
- **Flag:** `raw/courses/fireship.dev/react.gg/00_The Big Picture.md` is essentially empty (external links + Claude chat link, no prose). Stub summary created; "Why React?" parked as an open question.
- Cross-source reuse: react.dev Quick Start and Epic React chapters share concept pages (`[[react-components]]`, `[[react-jsx]]`, `[[react-props]]`, `[[react-fragments]]`) rather than duplicating.

## [2026-05-17] ingest | Eloquent JavaScript intro + Total TypeScript setup

- Pillar: software-engineering
- 2 summaries created: [[eloquent-js-00-introduction]], [[total-typescript-00-setup]]
- 3 new concepts: [[programming-languages]], [[ts-vs-js]], [[ts-compiler-tsc]]
- **Decision:** Total TypeScript ch00 teases `tsc` but doesn't cover `tsconfig.json`. A `ts-tsconfig` page was deliberately *not* created — flagged as open question for the chapter that covers it.
- **Decision:** Eloquent JS intro's positional-binary table was too thin to justify a dedicated concept page; parked as open question.

## [2026-05-17] ingest | Epic Web Programming Foundations ch00-02

- Pillar: software-engineering
- 3 summaries created: [[epic-web-pf-00-expressions-outputs]], [[epic-web-pf-01-variables-immutability]], [[epic-web-pf-02-primitive-types]]
- 6 new concepts: [[programming-expressions]], [[programming-variables]], [[programming-immutability]], [[programming-primitive-types]], [[js-template-literals]], [[js-variable-declarations]]
- **Decision:** Split universal concepts (`programming-*`) from JS-specific syntax (`js-*`). The keyword `const` is JS-specific; the *concept* of immutability is universal.
- "Floating-point money" recurred in two pages but did not earn a dedicated concept page yet — parked as open question; promote if it recurs.

## [2026-05-17] ingest | FM Enterprise UI ch00 + BYO HTTP Server in TypeScript

- Pillar: software-engineering
- 2 summaries created: [[fm-enterprise-ui-00-architecture-patterns]], [[project-byo-http-server-typescript]]
- 5 new concepts: [[ui-arch-three-axes]], [[monorepo-vs-polyrepo]], [[deployment-topology]], [[http-protocol-basics]], [[tcp-sockets]]
- 2 new patterns (first pattern pages in the wiki): [[monolithic-frontend]], [[micro-frontends]] — both use the full Context/Problem/Solution/Trade-offs structure.
- **Flag:** `raw/projects/Build your own HTTP Server in TypeScript.md` ends mid-sentence at "Read Header". Summary status set to `in-progress`.
- **Decision:** `monorepo-vs-polyrepo`, `deployment-topology`, `http-protocol-basics`, `tcp-sockets`, `dom-create-element` kept unprefixed — they are general-software-engineering concepts, not UI- or network-specific.

## [2026-05-17] consolidation | Rebuilt index.md from disk

- Five parallel ingest agents ran concurrently and (per instruction) skipped index/log updates. This consolidation pass rebuilt `wiki/index.md` from the on-disk file tree.
- **Skipped (raw sources that are frontmatter-only stubs):** `raw/books/Learning Go/01_Predeclared Types and Declarations.md`, `raw/books/Effective C/Effective C.md` and subdir, `raw/books/Zero Trust Networks/Zero Trust Networks.md` and subdir, `raw/books/Staff Engineer.../Staff Engineer...md` and subdir, `raw/courses/Epic React/React Fundamentals/05_Styling.md`, `raw/courses/fireship.dev/Modern JavaScript/00_Variable Declarations.md`, `raw/documentation/react.dev/01_Thinking in React.md`, `raw/courses/CS50/CS50X/Week-0_Scratch.md`, plus all hub files (frontmatter + chapter-link lists, no content).
- **Totals after this batch:** 24 summary pages, 35 concept pages, 2 pattern pages.

## [2026-06-09] ingest | Batch ingest — 8 thematic clusters

- **27 raw sources ingested** across 8 thematic clusters in a single batch session.
- **Pillars touched:** software-engineering (heavy), soft-skills (first content ever).
- **Approach:** 8 parallel ingest sub-agents were dispatched but blocked by Write tool denials in their sandbox. They returned detailed plans; the parent session executed all writes from those plans.

### Cluster 1 — JS Module Systems (2 sources)

- Sources: `raw/courses/fireship.dev/Advanced JavaScript/00_From IIFEs to CommonJS to ES6 Modules.md`, `raw/articles/JavaScript ES6 Modules vs CommonJS.md`.
- Summaries: [[advanced-js-00-iifes-commonjs-es6-modules]], [[article-js-es6-modules-vs-commonjs]].
- Concepts: [[js-modules-history]], [[js-iife]], [[js-commonjs]], [[js-es-modules]], [[tree-shaking]], [[commonjs-vs-esm-interop]], [[js-barrel-files]], [[js-dynamic-imports]].

### Cluster 2 — React Advanced (2 sources)

- Sources: `raw/courses/Epic React/Advanced React Patterns/00_Composition.md`, `raw/courses/Epic React/React Fundamentals/05_Styling.md` (previously a stub, now has content).
- Summaries: [[epic-react-arp-00-composition]], [[epic-react-rf-05-styling]].
- New concepts: [[react-composition]], [[prop-drilling]], [[react-layout-components]], [[react-styling-options]].
- Updated existing: [[react-components]] (domain-vs-layout framing), [[react-props]] (passing React elements as props).

### Cluster 3 — Go with Tests (2 sources)

- Sources: `raw/courses/Learn Go with Tests/00_Install Go.md`, `01_Hello World.md`.
- Summaries: [[learn-go-with-tests-00-install-go]], [[learn-go-with-tests-01-hello-world]].
- New concepts: [[go-testing-package]], [[go-subtests]], [[go-test-helpers]], [[tdd-red-green-refactor]] (the latter is a cross-pillar concept candidate — links into [[learning-encoding-and-recall]]).
- Updated existing: [[go-modules]], [[go-variables]], [[go-functions]] (named returns), [[go-conditionals]], [[go-packages]].

### Cluster 4 — CSS / Tailwind / Design Tokens (3 sources)

- Sources: `raw/courses/scrimba/Learn CSS Variables.md`, `raw/documentation/tailwindcss.com/Build UIs that dont suck.md`, `raw/documentation/tailwindcss.com/Tailwind CSS Core Concepts.md`.
- Summaries: [[scrimba-learn-css-variables]], [[tailwind-build-uis-that-dont-suck]], [[tailwind-core-concepts]].
- Concepts: [[css-custom-properties]], [[utility-first-css]], [[tailwind-variants]], [[tailwind-spacing-scale]], [[tailwind-class-composition]], [[design-tokens]].

### Cluster 5 — Tooling / Misc (4 sources) — first soft-skills content!

- Sources: `raw/courses/animations.dev/00_Animation Theory.md`, `raw/videos/Git Worktree - NetNinja.md`, `raw/videos/Learn Dangerously Fast.md`, `raw/videos/Zod.md`.
- Software-engineering summaries: [[animations-dev-00-animation-theory]], [[video-git-worktree-netninja]], [[video-zod]].
- Software-engineering concepts: [[animation-purpose-and-pacing]], [[git-worktree]], [[zod]], [[runtime-type-validation]], [[zod-schema-as-source-of-truth]], [[parse-vs-safe-parse]].
- Software-engineering pattern: [[parallel-development-with-worktrees]].
- **Soft-skills summary**: [[video-learn-dangerously-fast]] (the first soft-skills content in the wiki).
- **Soft-skills concepts**: [[learning-encoding-and-recall]], [[desirable-difficulty]], [[active-recall]], [[priming-and-schema-building]].
- **Flagged transcription errors in `raw/videos/Zod.md`**: `z.number()min(18)` (missing `.`); `z.literal(['open', 'close'])` (should be `z.enum`). Raw is read-only; flagging here for a future fix.

### Cluster 6 — Component Libraries / Storybook (3 sources)

- Sources: `raw/articles/Building Components with Radix UI.md`, `raw/courses/Build UI/Advanced Radix UI/00_Animated Switch.md`, `raw/documentation/storybook.js.org/Intro to Storybook.md`.
- Summaries: [[article-building-components-radix-ui]], [[build-ui-radix-00-animated-switch]], [[intro-to-storybook]].
- Concepts: [[radix-primitives]], [[radix-themes]], [[headless-component]], [[aschild-and-slot]], [[controlled-vs-uncontrolled]], [[compound-components]], [[storybook]], [[story]], [[args-and-controls]], [[component-driven-development]].
- Patterns: [[compound-component-pattern]], [[headless-ui-library]].

### Cluster 7 — TanStack Query (3 sources)

- Sources: `raw/courses/fireship.dev/query.gg/00_Laying the Foundation.md`, `raw/projects/tanstack-query basic project.md`, `raw/videos/TanStack Query Crash Course.md`.
- Summaries: [[query-gg-00-laying-the-foundation]], [[project-tanstack-query-basic]], [[video-tanstack-query-crash-course]].
- Concepts: [[tanstack-query]], [[server-state-vs-client-state]], [[query-key]], [[query-client]], [[use-query]], [[query-cache-and-stale-time]], [[query-invalidation]], [[use-mutation]] (marked `in-progress` — sources don't fully cover optimistic updates), [[query-suspense-mode]].

### Cluster 8 — Monorepos / Build Tooling (8 sources)

- Sources: `raw/articles/Mastering pnpm Workspaces.md`, `raw/articles/Monorepos for Developers.md`, `raw/documentation/nx.dev/00_Introduction to Nx.md`, `raw/documentation/pnpm.io/pnpm.io.md`, `raw/documentation/turborepo/00_Understanding Monorepos.md`, `raw/videos/Monorepos - fireship.dev.md`, `raw/videos/Opinions after using a monorepo for 12 months.md`, `raw/videos/Turborepo and Monorepos clearly explained.md`.
- Summaries: [[mastering-pnpm-workspaces]], [[monorepos-for-developers]], [[nx-dev-00-introduction]], [[pnpm-io-overview]], [[turborepo-00-understanding-monorepos]], [[video-monorepos-fireship]], [[video-monorepo-12-months-opinions]], [[video-turborepo-monorepos-explained]].
- Concepts: [[pnpm-workspaces]], [[pnpm-content-addressable-store]], [[phantom-dependencies]], [[dependency-hoisting]], [[workspace-protocol]], [[monorepo-package-graph]], [[task-orchestration]], [[remote-caching]], [[nx-affected]], [[turborepo-pipelines]].
- Pattern: [[monorepo]] — Context/Problem/Solution/Trade-offs.
- Updated existing: [[monorepo-vs-polyrepo]] — extended with monorepo-tool material, AI-agent context, single-team rule, "start with a monorepo" advice.
- **Notable tension between sources**: [[turborepo-00-understanding-monorepos]] says "start with a monorepo"; [[video-monorepo-12-months-opinions]] says "only a single team should be working on a monorepo." Both can be true. Documented in [[monorepo]] Trade-offs.

### Skipped sources

- Sources that are still frontmatter-only stubs as of this date: `raw/books/Learning Go/01_Predeclared Types and Declarations.md`, `raw/courses/Epic React/React Fundamentals/06_Forms.md`, `raw/courses/Learn Go with Tests/02_Integers.md`, `raw/documentation/nx.dev/01_Step by Step Guide to implement Nx.md`, `raw/documentation/nx.dev/02_From PNPM Workspaces to Distributed CI.md`, `raw/courses/the cascade by Kevin Powell/00_HTML.md`, `raw/documentation/react.dev/01_Thinking in React.md`.
- Sources that are mostly external links (no substantive prose): `raw/documentation/radix.ui/radix.ui.md`.
- Project file last "added some more notes" but still ends at the "Read Header" placeholder — `raw/projects/Build your own HTTP Server in TypeScript.md` not re-ingested.

### Totals after this batch

- **48 summary pages** (was 24).
- **86 concept pages** (was 35).
- **6 pattern pages** (was 2).
- **5 soft-skills pages** (was 0) — first soft-skills content.
- Wiki has gone from "scaffolded with Go + React fundamentals" to a meaningful coverage of modern frontend infrastructure (monorepos, build tooling, data fetching, component libraries, validation, learning craft).

## [2026-06-09] consolidation | index.md, log.md, synthesis.md rebuilt

- Rebuilt `wiki/index.md` from on-disk state with new topic clusters: Go testing, JS module systems, runtime type validation, TanStack Query, Radix/Storybook, CSS/Tailwind, Monorepos, soft-skills/learning.
- Appended this batch entry to `wiki/log.md`.
- Updated `wiki/synthesis.md` to reflect the major thematic shift from "scaffolding" to "modern frontend infrastructure + first soft-skills."

## [2026-06-09] lint | First full lint pass + applied fixes

- **Mechanical lint** (graph): 0 orphan pages, 0 stale `updated:` dates >90 days, 21 dangling links surveyed.
- **Dangling links categorized**: 9 raw-side brand/hub references (intentional cross-vault); 12 wiki-side missing pages.
- **5 dangling-link concepts promoted to real pages** (with `status: in-progress` since they're awaiting dedicated sources):
  - [[microservices]] — was 3 refs; canonical backend-microservices contrast for frontend architecture.
  - [[module-bundlers]] — was 2 refs; Vite/esbuild/Rollup/Webpack overview.
  - [[continuous-integration]] — was 1 ref; CI/CD primer.
  - [[css-specificity]] — was 1 ref; specificity tuple, cascade, utility-first flattening.
  - [[silent-failure]] — was 1 ref; common shapes + prevention.
- **5 remaining dangling links left deliberately** (deferred to future sources): `[[table-driven-tests]]`, `[[animation-easing-curves]]`, `[[animation-duration-heuristics]]`, `[[module-boundary-rules]]`, `[[programming-values-types]]`.
- **Stale `_(future)_` markers stripped (4)** from `epic-react-rf-05-styling` and `react-styling-options`: `[[utility-first-css]]`, `[[tailwind-class-composition]]` (×2), `[[css-custom-properties]]` — all now exist.
- **Anchor link fixed**: `[[react-styling-options#naming-mismatch]]` — shortened the corresponding heading from `### Naming mismatch — JSX uses DOM property names` to `### Naming mismatch` so the anchor resolves. Subtitle moved into body text.
- **Bulk promoted 25 pages** from `status: in-progress` → `status: stable` (content was complete; status was inherited from May-17 batch). Kept the 6 genuinely-in-progress pages: `animation-purpose-and-pacing`, `go-error-handling`, `project-byo-http-server-typescript`, `react-gg-00-big-picture`, `three-dots-labs-go-07-errors`, `use-mutation`. Also kept the 4 new dangling-link concepts at `in-progress` since they await dedicated sources.
- **CLAUDE.md updated**: added a Wikilinks convention note that raw-side cross-vault references (`[[TypeScript]]`, `[[React]]`, `[[CLAUDE]]`, etc.) are allowed and should be categorized separately from "missing wiki pages" in future lint passes.
- **Index updated**: 5 new concept entries added under appropriate clusters (Architecture/Backend, CSS, Build & deployment, Error handling).
- **Contradictions**: 1 captured (monorepo single-team-vs-cross-team in [[monorepo]] and [[monorepo-vs-polyrepo]]); 0 uncaptured.
- **Coverage gaps flagged**: Leadership pillar (0 pages), soft-skills (only meta-learning so far), no first-class sources yet for microservices, CI/CD, CSS cascade, silent failures, shadcn/ui, testing strategy beyond Storybook, distributed systems, databases, AI-assisted development.

## [2026-06-09] ingest | Full-coverage sweep — every raw file represented

User directive: "ingest everything missing in raw/; don't skip anything." Previous batches deliberately skipped frontmatter-only stubs and hub files. This pass closes the gap so every raw file has at least a wiki-side counterpart.

### Real-content sources ingested (2)

- `raw/courses/Frontend Masters/Design Systems with Storybook v2/Design Systems with Storybook v2.md` — single-file substantial content (90 body lines). Summary: [[fm-design-systems-storybook-v2]]. New concept: [[storybook-config]] (the `main.ts`/`preview.ts` split + addon catalog).
- `raw/documentation/radix.ui/radix.ui.md` — substantive (169 body lines) — earlier wrongly classified as "links-only." Summary: [[radix-ui-overview]]. New concept: [[radix-internal-architecture]] (`Collection.Provider`, the "Impl" pattern, `Primitive.div` wrapper, `asChild` gotchas).

### Empty-chapter placeholders (10)

Each gets a placeholder summary with `status: in-progress` and an explicit "raw source has no body yet" callout. They surface in the index and prevent the lint pass from re-flagging them as missing.

- [[learning-go-ch01-predeclared-types]] — *Learning Go* ch01.
- [[build-ui-radix-01-apple-selector-group]], [[build-ui-radix-02-ios-slider]], [[build-ui-radix-03-animated-toast]] — Build UI: Advanced Radix UI ch01-03.
- [[epic-react-rf-06-forms]] — Epic React: React Fundamentals ch06.
- [[learn-go-with-tests-02-integers]] — Learn Go with Tests ch02.
- [[the-cascade-00-html]] — The Cascade (Kevin Powell) ch00.
- [[nx-dev-01-step-by-step-guide]], [[nx-dev-02-pnpm-workspaces-to-distributed-ci]] — nx.dev ch01-02.
- [[react-dev-01-thinking-in-react]] — react.dev ch01.

### Hub-summaries (37)

Each raw-side hub (course/book/doc-set root) now has a wiki-side mirror — a small "hub-summary" page tagged `[hub]` that catalogs ingested-vs-pending chapters and links back to the raw hub. They serve as navigation anchors.

**Book hubs** (4): [[effective-c-hub]], [[eloquent-javascript-hub]], [[learning-go-hub]], [[zero-trust-networks-hub]] + [[staff-engineer-book-hub]] **(under Leadership pillar — first Leadership content!)**.

**Course platform hubs** (27): [[build-ui-hub]], [[advanced-radix-ui-hub]], [[epic-react-hub]], [[react-fundamentals-hub]], [[advanced-react-patterns-hub]], [[epic-web-hub]], [[programming-foundations-hub]], [[fireship-dev-hub]], [[advanced-javascript-hub]], [[query-gg-hub]], [[frontend-masters-hub]], [[fm-enterprise-ui-development-hub]], [[fm-mastering-chrome-devtools-hub]], [[fm-design-systems-storybook-v2-hub]], [[joshcomeau-hub]], [[the-joy-of-react-hub]], [[whimsical-animations-hub]], [[css-for-javascript-developers-hub]], [[kodekloud-hub]], [[learn-go-with-tests-hub]], [[scrimba-hub]], [[the-cascade-hub]], [[html-and-css-for-absolute-beginner-hub]], [[three-dots-labs-academy-hub]], [[total-typescript-hub]], [[typescript-pro-essentials-hub]], [[animations-dev-hub]].

**Documentation hubs** (8): [[nx-dev-hub]], [[react-dev-hub]], [[storybook-js-org-hub]], [[tailwindcss-com-hub]], [[turborepo-hub]], [[production-monorepos-with-turborepo-hub]], [[radix-ui-hub]], [[pnpm-io-hub]].

### Schema-evolution note

Introduced a `[hub]` tag convention for hub-summary pages. Type stays `summary`; tag list now leads with `hub`. These pages live in the appropriate pillar's `summaries/` dir and follow the standard frontmatter shape (no schema change to CLAUDE.md needed; just a tag addition).

### Leadership pillar — opened

The Leadership pillar's "Summaries" subsection is no longer empty. [[staff-engineer-book-hub]] seeds the pillar — it's a hub-summary referencing Will Larson's *Staff Engineer*. The book itself still needs chapter content in raw before substantive summaries can land; the hub serves as the named anchor for that future work.

### Totals after this batch

- **+2 substantive summary pages** (Design Systems with Storybook v2, Radix UI overview).
- **+2 new concept pages** ([[storybook-config]], [[radix-internal-architecture]]).
- **+10 placeholder chapter pages**.
- **+37 hub-summary pages** (1 in Leadership, 36 in Software Engineering).
- **= 51 new wiki files** this pass.
- Every raw markdown file now has at least one wiki-side counterpart.

## [2026-06-09] lint+cleanup | Rigorous coverage re-verification + structural fixes

User asked for a careful re-check of "what's missed in `raw/`". A more rigorous verification (frontmatter `source:` matching, not just substring search) confirmed **0 raw files missing ingestion** — every one of the 90 raw `.md` files has a wiki-side counterpart. Two adjacent issues surfaced and were applied as approved.

### Verification

- **90 raw `.md` files**, all claimed by at least one wiki `source:` field.
- Edge cases ruled out: no symlinks, no hidden .md, only non-md content is macOS `.DS_Store`.
- 11 raw files exist on disk but aren't yet git-tracked (recently-added, not committed). Wiki ingest is independent of git state.

### Cleanup A — annotated 10 stale-source wiki pages

These wiki pages survived raw-vault cleanups where the underlying raw files were deleted. Each had `source:` pointing at a path that no longer exists. Per the new convention, replaced with `former_source:` + `source_status: deleted` and added a `> [!NOTE] Raw source deleted` callout near the top of the body.

Affected pages: [[react-gg-00-big-picture]], [[three-dots-labs-go-00-hello]], [[three-dots-labs-go-01-variables]], [[three-dots-labs-go-02-functions]], [[three-dots-labs-go-03-http-server]], [[three-dots-labs-go-04-arrays]], [[three-dots-labs-go-05-slices]], [[three-dots-labs-go-06-conditionals]], [[three-dots-labs-go-07-errors]], [[tour-of-go-00-packages]].

### Cleanup B — demoted 3 redundant hub-summaries to pointer pages

The bulk hub-generator from the previous batch created hub pages for every raw hub, including 3 raws whose substantive content already had a dedicated summary. Both pages were claiming `source:` for the same raw file — a structural duplication.

For each affected hub, removed `source:`, replaced body content with a brief "navigation alias" pointer, added `points-to:` frontmatter field referencing the substantive summary:

- [[pnpm-io-hub]] → points to [[pnpm-io-overview]].
- [[radix-ui-hub]] → points to [[radix-ui-overview]].
- [[fm-design-systems-storybook-v2-hub]] → points to [[fm-design-systems-storybook-v2]].

The substantive summaries themselves were not touched.

### CLAUDE.md — documented the new conventions

Added a section under Conventions → Frontmatter documenting:

- `source:` is canonical per-raw and unique.
- `former_source:` + `source_status: deleted` for surviving-but-orphaned wiki pages.
- `points-to:` for hub-shaped pointer pages whose underlying raw is already covered by a substantive summary.

### Verification (post-cleanup)

- **0 raw files** without wiki `source:` — unchanged.
- **0 wiki pages** with `source:` pointing at non-existent raws — was 10.
- **0 raw files** claimed by multiple wiki `source:` fields — was 3.

All three counters now read 0. Wiki graph is consistent.
