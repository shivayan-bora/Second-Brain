---
title: TypeScript Compiler (tsc)
pillar: software-engineering
type: concept
tags: [typescript, tooling, build-system, compiler, lsp]
status: in-progress
sources: ["[[total-typescript-00-setup]]"]
created: 2026-05-17
updated: 2026-05-17
---

# TypeScript Compiler (tsc)

## Definition

`tsc` is the **TypeScript Compiler** — a CLI tool that reads TypeScript source (`.ts`, `.tsx`) and emits JavaScript (`.js`). Browsers and Node.js cannot run TypeScript directly; `tsc` (or an equivalent transpiler like esbuild, swc, or Babel) is the bridge. `tsc` also performs type-checking, though in modern build pipelines the *emit* and *check* roles are often split between separate tools.

## Why it matters

`tsc` is the seam where TypeScript stops being a developer-experience layer and becomes runnable code. Every TypeScript project has to answer:

- **Who runs `tsc`?** A pre-commit hook, the CI build, the dev server, a bundler plugin?
- **What does it emit?** Which JavaScript version? Which module system? ES modules or CommonJS?
- **Is type-checking on the critical path?** Many teams emit JS with a fast tool (esbuild/swc) and run `tsc --noEmit` separately for type-checking — splitting speed from safety.

For a staff engineer, picking and tuning the compile step is a recurring decision that affects build times, CI flakiness, and how quickly type errors surface.

## Mechanics

### The TypeScript build pipeline

```
   .ts / .tsx  ──► [ tsc / esbuild / swc ]  ──►  .js  ──► browser / Node.js
        ▲
        │
   IDE + TypeScript LSP server
   (autocomplete, errors, refactors)
```

- You write code in `.ts` or `.tsx` files.
- The **TypeScript Language Server (LSP)** runs inside your IDE, continuously watching the code and providing autocomplete and inline error feedback. This is the *interactive* half of the toolchain.
- The **`tsc` CLI** runs as part of the build (or in a watch mode locally) and emits JavaScript. This is the *batch* half.
- The emitted JavaScript is then consumed by the runtime — browser or Node.js — exactly as if it had been hand-written JS.

### Contrast with the plain-JS pipeline

A JavaScript-only project skips the compile step entirely:

```
   .js / .jsx  ──►  browser / Node.js
```

The simplicity is real — no build step to maintain. The cost is the missing tooling experience (no static type-checking, weaker autocomplete). See [[ts-vs-js]] for the full trade-off.

### Two roles in one binary

`tsc` does two distinct jobs that are worth separating in your head:

1. **Type-checking** — verifies the program against the type system; produces errors and warnings.
2. **Emitting** — produces `.js` output (and optionally `.d.ts` declaration files, source maps).

In high-performance pipelines, these are often split:
- `esbuild` / `swc` / Babel handle emit (fast, no type-checking).
- `tsc --noEmit` handles type-checking (slower, runs in parallel or on CI).

## Examples

Minimum-friction compile of a single file:

```bash
tsc index.ts            # emits index.js next to the source
```

Typical project use, driven by `tsconfig.json`:

```bash
tsc                     # reads tsconfig.json, compiles the whole project
tsc --watch             # incremental recompile on change
tsc --noEmit            # type-check only, no JS output
```

Split-tool setup (common in modern bundler-driven projects):

```bash
# fast emit
esbuild src/index.ts --bundle --outfile=dist/index.js

# separate type-check, often run in CI
tsc --noEmit
```

## Related

- [[ts-vs-js]] — why this compile step exists in the first place.
- [[programming-languages]] — `tsc` is the canonical example of the "transpiled" execution model.

## Sources

- [[total-typescript-00-setup]] (`raw/courses/Total TypeScript/00_Kickstart your TypeScript Setup.md`)
