---
title: Wiki Index
type: index
updated: 2026-06-09
aliases: []
id: index
tags: []
---

# Index

Catalog of all wiki pages. Updated on every ingest. Organized by pillar → page type → topic cluster.

## Software Engineering

### Concepts

#### Go

- [[go-modules]] — Go's unit of source distribution and dependency tracking; `go.mod` at the root.
- [[go-toolchain]] — `go build` / `go fmt` / `go vet` — Go's bundled compile/format/static-check commands.
- [[go-packages]] — How Go organizes code into packages and the package/module relationship.
- [[go-variables]] — Variable declaration in Go: `var`, `:=`, zero values, type inference, grouped consts.
- [[go-functions]] — Functions in Go: signatures, multiple return values, named returns.
- [[go-http-server]] — Building an HTTP server with `net/http`.
- [[go-arrays]] — Fixed-size arrays.
- [[go-slices]] — Slices: Go's primary sequential collection; the backing-array model.
- [[go-conditionals]] — `if` / `switch` semantics and idioms.
- [[go-error-handling]] — Go's `error` interface and idiomatic error-handling patterns _(placeholder — raw source incomplete)_.

#### Go — Testing (TDD)

- [[go-testing-package]] — Stdlib `testing` package: `*testing.T`, `t.Errorf`/`t.Fatal`, `%q`, `testing.TB`.
- [[go-subtests]] — `t.Run("name", ...)` for grouping cases.
- [[go-test-helpers]] — `t.Helper()` + `testing.TB` for extractable assertion helpers.
- [[tdd-red-green-refactor]] — The TDD cycle as practiced in *Learn Go with Tests*.

#### JavaScript

- [[js-variable-declarations]] — `let` / `const` / `var` semantics in JavaScript.
- [[js-template-literals]] — Backtick strings, interpolation, and multi-line literals.

#### JavaScript — Module Systems

- [[js-modules-history]] — The arc: globals → IIFE → CJS → ESM.
- [[js-iife]] — IIFE module pattern.
- [[js-commonjs]] — Node's `require` / `module.exports`; synchronous, dynamic, browser-hostile.
- [[js-es-modules]] — `import` / `export`; static, live bindings, the substrate of tree-shaking.
- [[tree-shaking]] — Build-time dead-export elimination, enabled by static imports.
- [[commonjs-vs-esm-interop]] — The CJS↔ESM interop rules, sharp edges, dual builds.
- [[js-barrel-files]] — `index.ts` re-exports as a package's public API.
- [[js-dynamic-imports]] — `import()` for code splitting and conditional loading.

#### TypeScript

- [[ts-vs-js]] — TypeScript as a JS superset: history, motivation, trade-offs.
- [[ts-compiler-tsc]] — The `tsc` CLI, the build pipeline, emit/type-check split.

#### TypeScript — Runtime Validation

- [[zod-library|zod]] — Runtime schema validation library; the canonical answer in the TS ecosystem.
- [[runtime-type-validation]] — The broader category — why TS alone isn't enough at system boundaries.
- [[zod-schema-as-source-of-truth]] — `z.infer` / `z.input`; schema and type as one declaration.
- [[parse-vs-safe-parse]] — Zod's two error-handling modes.

#### React

- [[react-element-vs-component]] — The core React distinction: element (description) vs component (function/class).
- [[react-create-element]] — `React.createElement` — the underlying API behind JSX.
- [[react-create-root]] — `createRoot` and the modern React 18 mount API.
- [[react-jsx]] — JSX syntax, transpilation, how it compiles to `createElement` calls.
- [[react-components]] — Function components, the core React unit; domain-vs-layout split.
- [[react-props]] — Passing data (and elements) into components; props as immutable inputs.
- [[react-fragments]] — `<>…</>` to return multiple sibling elements.
- [[react-hooks]] — The hooks API surface (scaffolding for future content).
- [[react-typescript]] — Typing React components, props, and hooks.

#### React — Patterns & Composition

- [[react-composition]] — Passing React elements as props; the alternative to prop drilling + context.
- [[prop-drilling]] — The trade-off, not just the anti-pattern.
- [[react-layout-components]] — Components defining *where things go*, not *what they are*.
- [[react-styling-options]] — `style` vs `className`; the JSX/DOM naming gap; `React.ComponentProps`.

#### Architecture / Backend (referenced contrasts)

- [[microservices]] — Independently-deployable backend services; the canonical contrast to [[micro-frontends]] _(stub — awaiting first dedicated source)_.

#### React — Server State (TanStack Query)

- [[tanstack-query]] — Async state manager for server state; not a fetcher.
- [[server-state-vs-client-state]] — The mental-model frame.
- [[query-client]] — The cache + scheduler; `QueryClient` + `QueryClientProvider`.
- [[query-key]] — Cache identity; the `['posts', id]` array shape.
- [[use-query]] — The primary subscription hook.
- [[query-cache-and-stale-time]] — `staleTime` vs `gcTime`; the two-clock freshness model.
- [[query-invalidation]] — Active cache busting after mutations.
- [[use-mutation]] — Write-side counterpart with lifecycle hooks _(in-progress)_.
- [[query-suspense-mode]] — `useSuspenseQuery`; `data` never `undefined`.

#### Radix UI / Component Libraries

- [[radix-primitives]] — Unstyled, accessible React Primitives (Dialog, Switch, etc.).
- [[radix-themes]] — Pre-styled component layer on top of Primitives.
- [[radix-internal-architecture]] — `Collection.Provider`, the "Impl" pattern, `Primitive.div` wrapper.
- [[headless-component]] — The broader category (Radix as canonical example).
- [[aschild-and-slot]] — Radix's `asChild` + the Slot pattern.
- [[controlled-vs-uncontrolled]] — Library-design rule for stateful components.
- [[compound-components]] — `<Dialog.Root>`/`<Dialog.Trigger>` API shape.

#### Storybook / Component-Driven Development

- [[storybook]] — Frontend workshop tool; isolation + docs + testing.
- [[story]] — Named, isolated visual states in Component Story Format (CSF).
- [[args-and-controls]] — Runtime values + the controls panel.
- [[storybook-config]] — `main.ts` (build-time) vs `preview.ts` (run-time) config split.
- [[component-driven-development]] — Bottom-up UI methodology.

#### CSS / Tailwind / Design Tokens

- [[css-custom-properties]] — CSS variables; runtime-mutable, cascade-aware theming.
- [[css-specificity]] — The specificity tuple, the cascade, and why utility-first flattens it _(stub — awaiting first dedicated source)_.
- [[utility-first-css]] — The methodology, pros, cons, mitigations.
- [[tailwind-variants]] — `hover:`, `dark:`, `md:`, `[dir=rtl]:` prefixes.
- [[tailwind-spacing-scale]] — The discrete `1 = 0.25rem` numeric scale.
- [[tailwind-class-composition]] — `clsx`, `tailwind-merge`, the `cn()` helper.
- [[design-tokens]] — Named design decisions; CSS variables and utility classes as vehicles.

#### Animation / UX

- [[animation-purpose-and-pacing]] — Animation as a finite UX resource; the frequency-of-encounter test.

#### Programming fundamentals (cross-language)

- [[programming-languages]] — What a programming language is; compiled vs interpreted vs JIT vs transpiled.
- [[programming-expressions]] — Expressions vs statements across languages.
- [[programming-variables]] — Variables as named pointers; the universal pointer model.
- [[programming-immutability]] — Reassignment vs mutation; binding-vs-value immutability.
- [[programming-primitive-types]] — Primitives across JS, Go, Rust, etc.

#### Build & deployment / Monorepos

- [[makefiles]] — `make` targets, prerequisites, `.PHONY`, `.DEFAULT_GOAL` — language-agnostic build automation.
- [[module-bundlers]] — Vite, esbuild, Rollup, Webpack — the bridge from npm/CJS to browser-loadable bundles.
- [[continuous-integration]] — CI/CD pipelines + monorepo affected-only execution _(stub — awaiting first dedicated source)_.
- [[monorepo-vs-polyrepo]] — Repo-topology trade-offs (extended with monorepo-tool material).
- [[deployment-topology]] — How code deploys; the under-discussed third axis of UI architecture.
- [[pnpm-workspaces]] — pnpm's built-in monorepo support.
- [[pnpm-content-addressable-store]] — CAS + hard links; pnpm's disk-efficiency model.
- [[phantom-dependencies]] — The npm/Yarn hoisting trap.
- [[dependency-hoisting]] — Why npm/Yarn hoist; what it costs.
- [[workspace-protocol]] — `workspace:*`; in-monorepo dependency linking.
- [[monorepo-package-graph]] — The DAG that orchestrators traverse.
- [[task-orchestration]] — Caching + parallel + selective execution; the Nx/Turborepo umbrella.
- [[remote-caching]] — Shared build artifacts across machines/CI.
- [[nx-affected]] — Nx's change-aware execution model.
- [[turborepo-pipelines]] — Turborepo's `turbo.json` config surface.

#### UI architecture

- [[ui-arch-three-axes]] — Runtime, repo, and deployment as the three independent dimensions of UI architecture.

#### Networking & web platform

- [[http-protocol-basics]] — HTTP/1.1 wire format: request line, headers, body.
- [[tcp-sockets]] — Node's `net` socket abstraction; how TCP underlies HTTP.
- [[dom-create-element]] — `document.createElement` — the browser primitive React's `createElement` mirrors.

#### Git / Workflow

- [[git-worktree]] — Multiple checked-out branches sharing one `.git`.

#### Error handling / Quality

- [[silent-failure]] — The single hardest class of bug; common shapes and prevention _(stub — awaiting first dedicated source)_.

### Patterns

- [[monolithic-frontend]] — A single-codebase frontend deployed as one unit. Context / problem / solution / trade-offs.
- [[micro-frontends]] — Independently deployable frontend slices. Includes the build-time-coupling trap.
- [[monorepo]] — Single-repo, multi-project layout with task orchestration.
- [[compound-component-pattern]] — Namespace-of-subcomponents API shape for stateful UI components.
- [[headless-ui-library]] — Behavior + accessibility, no styles; the library-design pattern.
- [[parallel-development-with-worktrees]] — `git worktree` as a multi-stream workflow.

### Summaries

#### Books

- [[learning-go-ch00-environment-setup]] — _Learning Go_ ch. 0: modules, toolchain, Makefiles.
- [[eloquent-js-00-introduction]] — _Eloquent JavaScript_, Introduction.

#### Articles

- [[article-building-components-radix-ui]] — Refine.dev Radix overview (Primitives/Colors/Icons/Themes).
- [[article-js-es6-modules-vs-commonjs]] — Design-system framing of ESM vs CJS, barrels, dynamic imports.
- [[mastering-pnpm-workspaces]] — Long-form pnpm workspaces guide; layout, `workspace:*`, filtering.
- [[monorepos-for-developers]] — monorepo.tools: the well-defined-relationships criterion, polyrepo costs.

#### Documentation

- [[react-dev-00-quick-start]] — react.dev Quick Start: the canonical React intro.
- [[react-dev-01-thinking-in-react]] — react.dev Thinking in React _(placeholder — raw is empty)_.
- [[tour-of-go-00-packages]] — Tour of Go: Packages.
- [[nx-dev-00-introduction]] — Nx overview: tasks, caching, project graph, affected, migrate.
- [[nx-dev-01-step-by-step-guide]] — Nx step-by-step _(placeholder — raw is empty)_.
- [[nx-dev-02-pnpm-workspaces-to-distributed-ci]] — Nx PNPM→distributed CI _(placeholder — raw is empty)_.
- [[pnpm-io-overview]] — pnpm's structural advantages: CAS, strict layout, phantom deps.
- [[radix-ui-overview]] — Radix Primitives architecture: `Collection.Provider`, "Impl" pattern, `Primitive.div`, `asChild` gotchas.
- [[turborepo-00-understanding-monorepos]] — Monorepo + Turborepo intro; `turbo.json` walkthrough.
- [[tailwind-build-uis-that-dont-suck]] — Stretched-`<span>` accessible card-link pattern.
- [[tailwind-core-concepts]] — Utility-first, the Big Four utility categories, variants, scale.
- [[intro-to-storybook]] — Stories, args, decorators, MDX, CDD, theming.

#### Courses — Go

- [[three-dots-labs-go-00-hello]] — Three Dots Labs _Go in One Evening_ ch. 00: Hello.
- [[three-dots-labs-go-01-variables]] — ch. 01: Variables.
- [[three-dots-labs-go-02-functions]] — ch. 02: Functions.
- [[three-dots-labs-go-03-http-server]] — ch. 03: HTTP Server.
- [[three-dots-labs-go-04-arrays]] — ch. 04: Arrays.
- [[three-dots-labs-go-05-slices]] — ch. 05: Slices.
- [[three-dots-labs-go-06-conditionals]] — ch. 06: Conditionals.
- [[three-dots-labs-go-07-errors]] — ch. 07: Errors _(placeholder — raw source has unrelated content)_.
- [[learn-go-with-tests-00-install-go]] — *Learn Go with Tests* ch. 00: Install Go.
- [[learn-go-with-tests-01-hello-world]] — ch. 01: Hello World (TDD-flavored).
- [[learn-go-with-tests-02-integers]] — ch. 02: Integers _(placeholder — raw is empty)_.
- [[learning-go-ch01-predeclared-types]] — _Learning Go_ ch. 01: Predeclared Types and Declarations _(placeholder)_.

#### Courses — JavaScript / TypeScript

- [[total-typescript-00-setup]] — Total TypeScript ch. 00: Kickstart your TypeScript setup.
- [[advanced-js-00-iifes-commonjs-es6-modules]] — fireship.dev *Advanced JavaScript*: module-system arc.

#### Courses — React

- [[epic-react-rf-00-hello-world-js]] — Epic React: React Fundamentals ch. 00: Hello World in JS.
- [[epic-react-rf-01-raw-react-apis]] — ch. 01: Raw React APIs.
- [[epic-react-rf-02-using-jsx]] — ch. 02: Using JSX.
- [[epic-react-rf-03-custom-components]] — ch. 03: Custom Components.
- [[epic-react-rf-04-typescript]] — ch. 04: TypeScript.
- [[epic-react-rf-05-styling]] — ch. 05: Styling (`style`/`className`, JSX naming, `ComponentProps`).
- [[epic-react-rf-06-forms]] — ch. 06: Forms _(placeholder — raw is empty)_.
- [[epic-react-arp-00-composition]] — *Advanced React Patterns* ch. 00: Composition.
- [[react-gg-00-big-picture]] — react.gg "The Big Picture" _(stub — source not yet written)_.

#### Courses — Server State

- [[query-gg-00-laying-the-foundation]] — query.gg ch. 00: why TanStack Query exists.

#### Courses — Component Libraries

- [[build-ui-radix-00-animated-switch]] — Build UI *Advanced Radix UI* ch. 00: Animated Switch.
- [[build-ui-radix-01-apple-selector-group]] — ch. 01: Apple Selector Group _(placeholder — raw is empty)_.
- [[build-ui-radix-02-ios-slider]] — ch. 02: iOS Slider _(placeholder — raw is empty)_.
- [[build-ui-radix-03-animated-toast]] — ch. 03: Animated Toast _(placeholder — raw is empty)_.
- [[fm-design-systems-storybook-v2]] — Frontend Masters *Design Systems with Storybook v2*: setup + main.ts/preview.ts + basic stories.

#### Courses — Programming Foundations

- [[epic-web-pf-00-expressions-outputs]] — Epic Web Programming Foundations ch. 00: Expressions & outputs.
- [[epic-web-pf-01-variables-immutability]] — ch. 01: Variables & immutability.
- [[epic-web-pf-02-primitive-types]] — ch. 02: Primitive types.

#### Courses — Architecture

- [[fm-enterprise-ui-00-architecture-patterns]] — Frontend Masters _Enterprise UI Development_ ch. 00: UI architecture patterns.

#### Courses — CSS / Animation

- [[scrimba-learn-css-variables]] — Scrimba: CSS custom properties, scoping, JS interop, media-query swap.
- [[animations-dev-00-animation-theory]] — animations.dev ch. 00: animation as a finite UX resource.
- [[the-cascade-00-html]] — The Cascade (Kevin Powell) ch. 00: HTML _(placeholder — raw is empty)_.

#### Videos

- [[video-monorepos-fireship]] — fireship.dev: Nx vs Turborepo comparison at a glance.
- [[video-monorepo-12-months-opinions]] — 12-month operational reflection; the single-team rule.
- [[video-turborepo-monorepos-explained]] — Compact Turborepo intro.
- [[video-tanstack-query-crash-course]] — Wide-coverage TanStack Query walkthrough.
- [[video-git-worktree-netninja]] — `git worktree` workflow with bare-clone layout.
- [[video-zod]] — Zod walkthrough: schemas, parse/safeParse, `z.infer`, composition, transforms.

#### Projects

- [[project-byo-http-server-typescript]] — Build your own HTTP server in TypeScript _(in progress — raw source ends mid-sentence)_.
- [[project-tanstack-query-basic]] — Minimal Vite+React+TS+Tailwind+TanStack Query starter.

### Hubs

Hub-summary pages mirror each raw-side hub (course/book/doc-set root) and catalog what's ingested vs pending. Marked `tags: [hub]`.

#### Book hubs

- [[effective-c-hub]] — *Effective C* (Seacord). No chapters ingested.
- [[eloquent-javascript-hub]] — *Eloquent JavaScript* (Haverbeke). Intro ingested.
- [[learning-go-hub]] — *Learning Go* (Bodner). ch00 ingested, ch01 placeholder.
- [[zero-trust-networks-hub]] — *Zero Trust Networks* (Gilman & Barth). No chapters ingested.

#### Course platform hubs

- [[build-ui-hub]] — Build UI platform.
- [[advanced-radix-ui-hub]] — Build UI: Advanced Radix UI sub-course.
- [[epic-react-hub]] — Epic React platform.
- [[react-fundamentals-hub]] — Epic React: React Fundamentals.
- [[advanced-react-patterns-hub]] — Epic React: Advanced React Patterns.
- [[epic-web-hub]] — Epic Web platform.
- [[programming-foundations-hub]] — Epic Web: Programming Foundations.
- [[fireship-dev-hub]] — fireship.dev platform.
- [[advanced-javascript-hub]] — fireship.dev: Advanced JavaScript.
- [[query-gg-hub]] — fireship.dev: query.gg (TanStack Query).
- [[frontend-masters-hub]] — Frontend Masters platform.
- [[fm-enterprise-ui-development-hub]] — FM: Enterprise UI Development.
- [[fm-mastering-chrome-devtools-hub]] — FM: Mastering Chrome Developer Tools v4 (no chapters ingested).
- [[fm-design-systems-storybook-v2-hub]] — FM: Design Systems with Storybook v2.
- [[joshcomeau-hub]] — joshcomeau platform.
- [[the-joy-of-react-hub]] — joshcomeau: The Joy of React (no chapters ingested).
- [[whimsical-animations-hub]] — joshcomeau: Whimsical Animations (no chapters ingested).
- [[css-for-javascript-developers-hub]] — joshcomeau: CSS for JavaScript Developers (no chapters ingested).
- [[kodekloud-hub]] — KodeKloud platform (no chapters ingested).
- [[learn-go-with-tests-hub]] — Learn Go with Tests.
- [[scrimba-hub]] — Scrimba platform.
- [[the-cascade-hub]] — The Cascade (Kevin Powell) platform.
- [[html-and-css-for-absolute-beginner-hub]] — The Cascade: HTML and CSS for Absolute Beginner.
- [[three-dots-labs-academy-hub]] — Three Dots Labs Academy.
- [[total-typescript-hub]] — Total TypeScript platform.
- [[typescript-pro-essentials-hub]] — Total TypeScript: Pro Essentials.
- [[animations-dev-hub]] — animations.dev platform.

#### Documentation hubs

- [[nx-dev-hub]] — nx.dev documentation.
- [[react-dev-hub]] — react.dev documentation.
- [[storybook-js-org-hub]] — storybook.js.org documentation.
- [[tailwindcss-com-hub]] — tailwindcss.com documentation.
- [[turborepo-hub]] — turborepo.com documentation.
- [[production-monorepos-with-turborepo-hub]] — Turborepo: Production Monorepos learn-track.
- [[radix-ui-hub]] — radix-ui.com documentation.
- [[pnpm-io-hub]] — pnpm.io documentation.

## Leadership

### Concepts

_(none yet)_

### Archetypes

_(none yet)_

### Summaries

#### Books — Hubs (seeded, no chapters ingested)

- [[staff-engineer-book-hub]] — Will Larson's *Staff Engineer: Leadership Beyond the Management Track*. **Highest-priority leadership source.** No chapters ingested yet — raw book file is currently empty.

## Soft Skills

### Concepts

#### Learning / Meta-Learning

- [[learning-encoding-and-recall]] — The two-component model that defines effective learning techniques.
- [[desirable-difficulty]] — Learning slightly above your current level; meaningful mistakes as fuel.
- [[active-recall]] — Free, uncued production from memory; the counter to summarization.
- [[priming-and-schema-building]] — Big-picture-first vs break-it-down-and-isolate.

### Summaries

#### Videos

- [[video-learn-dangerously-fast]] — Meta-learning video pushing back on five common myths.
