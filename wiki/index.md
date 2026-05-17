---
title: Wiki Index
type: index
updated: 2026-05-17
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
- [[go-variables]] — Variable declaration in Go: `var`, `:=`, zero values, type inference.
- [[go-functions]] — Functions in Go: signatures, multiple return values, named returns.
- [[go-http-server]] — Building an HTTP server with `net/http`.
- [[go-arrays]] — Fixed-size arrays.
- [[go-slices]] — Slices: Go's primary sequential collection; the backing-array model.
- [[go-conditionals]] — `if` / `switch` semantics and idioms.
- [[go-error-handling]] — Go's `error` interface and idiomatic error-handling patterns _(placeholder — raw source incomplete)_.

#### JavaScript / TypeScript

- [[js-variable-declarations]] — `let` / `const` / `var` semantics in JavaScript.
- [[js-template-literals]] — Backtick strings, interpolation, and multi-line literals.
- [[ts-vs-js]] — TypeScript as a JS superset: history, motivation, trade-offs.
- [[ts-compiler-tsc]] — The `tsc` CLI, the build pipeline, the emit/type-check split (esbuild/swc + `tsc --noEmit`).

#### React

- [[react-element-vs-component]] — The core React distinction: element (description) vs component (function/class).
- [[react-create-element]] — `React.createElement` — the underlying API behind JSX.
- [[react-create-root]] — `createRoot` and the modern React 18 mount API.
- [[react-jsx]] — JSX syntax, transpilation, how it compiles to `createElement` calls.
- [[react-components]] — Function components, the core React unit.
- [[react-props]] — Passing data into components; props as immutable inputs.
- [[react-fragments]] — `<>…</>` to return multiple sibling elements.
- [[react-hooks]] — The hooks API surface (scaffolding for future content).
- [[react-typescript]] — Typing React components, props, and hooks.

#### Programming fundamentals (cross-language)

- [[programming-languages]] — What a programming language is; compiled vs interpreted vs JIT vs transpiled.
- [[programming-expressions]] — Expressions vs statements across languages.
- [[programming-variables]] — Variables as named pointers; the universal pointer model.
- [[programming-immutability]] — Reassignment vs mutation; binding-vs-value immutability.
- [[programming-primitive-types]] — Primitives across JS, Go, Rust, etc.

#### Build & deployment

- [[makefiles]] — `make` targets, prerequisites, `.PHONY`, `.DEFAULT_GOAL` — language-agnostic build automation.
- [[monorepo-vs-polyrepo]] — Repo-topology trade-offs.
- [[deployment-topology]] — How code deploys (single artifact vs multiple vs independent) — the under-discussed third axis of UI architecture.

#### UI architecture

- [[ui-arch-three-axes]] — Runtime, repo, and deployment as the three independent dimensions of UI architecture.

#### Networking & web platform

- [[http-protocol-basics]] — HTTP/1.1 wire format: request line, headers, body.
- [[tcp-sockets]] — Node's `net` socket abstraction; how TCP underlies HTTP.
- [[dom-create-element]] — `document.createElement` — the browser primitive React's `createElement` mirrors.

### Patterns

- [[monolithic-frontend]] — A single-codebase frontend deployed as one unit. Context / problem / solution / trade-offs.
- [[micro-frontends]] — Independently deployable frontend slices. Context / problem / solution / trade-offs, including the build-time-coupling trap.

### Summaries

#### Books

- [[learning-go-ch00-environment-setup]] — _Learning Go_ ch. 0: modules, toolchain, Makefiles.
- [[eloquent-js-00-introduction]] — _Eloquent JavaScript_, Introduction.

#### Documentation

- [[react-dev-00-quick-start]] — react.dev Quick Start: the canonical React intro.
- [[tour-of-go-00-packages]] — Tour of Go: Packages.

#### Courses — Go

- [[three-dots-labs-go-00-hello]] — Three Dots Labs _Go in One Evening_ ch. 00: Hello.
- [[three-dots-labs-go-01-variables]] — ch. 01: Variables.
- [[three-dots-labs-go-02-functions]] — ch. 02: Functions.
- [[three-dots-labs-go-03-http-server]] — ch. 03: HTTP Server.
- [[three-dots-labs-go-04-arrays]] — ch. 04: Arrays.
- [[three-dots-labs-go-05-slices]] — ch. 05: Slices.
- [[three-dots-labs-go-06-conditionals]] — ch. 06: Conditionals.
- [[three-dots-labs-go-07-errors]] — ch. 07: Errors _(placeholder — raw source has unrelated content)_.

#### Courses — JavaScript / TypeScript

- [[total-typescript-00-setup]] — Total TypeScript ch. 00: Kickstart your TypeScript setup.

#### Courses — React

- [[epic-react-rf-00-hello-world-js]] — Epic React: React Fundamentals ch. 00: Hello World in JS.
- [[epic-react-rf-01-raw-react-apis]] — ch. 01: Raw React APIs.
- [[epic-react-rf-02-using-jsx]] — ch. 02: Using JSX.
- [[epic-react-rf-03-custom-components]] — ch. 03: Custom Components.
- [[epic-react-rf-04-typescript]] — ch. 04: TypeScript.
- [[react-gg-00-big-picture]] — react.gg "The Big Picture" _(stub — source not yet written)_.

#### Courses — Programming Foundations

- [[epic-web-pf-00-expressions-outputs]] — Epic Web Programming Foundations ch. 00: Expressions & outputs.
- [[epic-web-pf-01-variables-immutability]] — ch. 01: Variables & immutability.
- [[epic-web-pf-02-primitive-types]] — ch. 02: Primitive types.

#### Courses — Architecture

- [[fm-enterprise-ui-00-architecture-patterns]] — Frontend Masters _Enterprise UI Development_ ch. 00: UI architecture patterns.

#### Projects

- [[project-byo-http-server-typescript]] — Build your own HTTP server in TypeScript _(in progress — raw source ends mid-sentence)_.

## Leadership

### Concepts

_(none yet)_

### Archetypes

_(none yet)_

### Summaries

_(none yet)_

## Soft Skills

### Concepts

_(none yet)_

### Summaries

_(none yet)_
