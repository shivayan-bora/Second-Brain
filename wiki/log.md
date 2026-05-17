---
title: Wiki Log
type: log
updated: 2026-05-17
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
