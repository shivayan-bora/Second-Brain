---
title: "Module Bundlers"
pillar: software-engineering
type: concept
tags: [javascript, build-system, bundlers, webpack, vite, esbuild]
status: stable
sources: ["[[advanced-js-00-iifes-commonjs-es6-modules]]", "[[js-commonjs]]"]
created: 2026-06-09
updated: 2026-06-09
---

# Module Bundlers

## Definition

A **module bundler** is a build-time tool that walks a JavaScript module graph from one or more entry points, resolves every `import`/`require`, and emits the result as one or more bundled output files the browser can load. Modern examples: **Vite**, **esbuild**, **Rollup**, **Webpack**, **Turbopack**, **Parcel**.

## Why it matters

Module bundlers exist because of an awkward fact: **browsers natively support [[js-es-modules|ESM]] today, but the npm ecosystem still ships heavy CJS, source needs transformation (TS → JS, JSX → JS), and you want optimization (minification, [[tree-shaking]], code splitting).** The bundler is the glue that makes the npm ecosystem work in the browser.

Knowing the bundler model is what lets you debug "why is my bundle 800KB" issues, understand chunk boundaries, and reason about [[js-dynamic-imports|dynamic imports]] as code-split points.

## The bundler model

1. **Entry points** declared (typically `src/index.ts`, sometimes multiple).
2. **Walk the import graph** — every `import` resolves to a file (relative path, npm package, alias).
3. **Transform each file** — TypeScript → JS, JSX → JS, CSS → JS modules, etc., via loaders/plugins.
4. **Apply optimizations** — [[tree-shaking|dead-export elimination]], minification, scope hoisting, constant folding.
5. **Emit bundles** — one or more JS files, plus CSS, source maps, and assets.
6. **Code splitting** — split at [[js-dynamic-imports|dynamic-import boundaries]] for lazy loading.

## The modern landscape

| Bundler | Strength | Weakness |
|---|---|---|
| **Vite** | Fast dev (native ESM in browser) + Rollup for prod | Two build systems = some inconsistency |
| **esbuild** | Insanely fast (Go-native) | Smaller plugin ecosystem |
| **Rollup** | Best tree-shaking + library output | Slower for big apps |
| **Webpack** | Most-mature plugin ecosystem | Heavy config; slow on large projects |
| **Turbopack** | Vercel's Rust-native; Next.js default | Newer, fewer integrations |
| **Parcel** | Zero-config | Less control |

For **library authors**: Rollup or tsup (which wraps Rollup/esbuild) emit clean CJS+ESM+`.d.ts` bundles for npm publishing.

For **app authors**: Vite (or whatever the framework defaults to — Next.js→Turbopack, Remix→Vite, Nuxt→Vite).

## The dev-server vs production-build split

Modern bundlers (Vite especially) bifurcate:

- **Dev server**: serve native ESM directly to the browser; transform files on demand. Almost-instant HMR.
- **Production build**: full bundle + minify + tree-shake + split chunks. Optimized for delivery.

This is why Vite feels fast in development — there's *no bundling* during dev. The "bundle" only happens at `vite build`.

## What bundlers solve

- **CJS → browser-loadable**. [[js-commonjs|CommonJS]] is browser-hostile (synchronous `require`); bundlers flatten the graph at build time.
- **TS/JSX transformation**. The browser doesn't speak TypeScript; the bundler delegates to `swc`/`esbuild`/`tsc`.
- **Asset references in code**. `import logo from './logo.svg'` works because the bundler emits the SVG as an asset and returns the URL.
- **Code splitting**. [[js-dynamic-imports|`import()`]] becomes a chunk boundary; the chunks load on demand.
- **Tree-shaking**. Static [[js-es-modules|ESM]] imports allow dead exports to be dropped.
- **Source maps**. Bundle output points back at original source for debugging.

## Where bundlers don't sit well

- **Monorepo task graphs.** Bundlers operate at the project level; [[task-orchestration|Turborepo/Nx]] operate above them. The bundler is one task per package; the orchestrator decides which packages to rebuild.
- **Server-only code.** Node can execute most ESM/CJS without a bundler; bundling is usually optional on the server (though tools like esbuild's bundle mode are common for serverless deploys).
- **Library output**: bundlers can do it, but `tsc --declaration` + a small Rollup config is often cleaner than full Webpack/Vite setups.

## Related

- [[js-modules-history]] — bundlers exist because the JS module story was patched-over.
- [[js-commonjs]] — synchronous require is what made bundlers necessary in the browser.
- [[js-es-modules]] — static imports are what makes [[tree-shaking]] possible.
- [[js-dynamic-imports]] — `import()` defines bundler chunk boundaries.
- [[tree-shaking]] — what the bundler does with reachability analysis.
- [[task-orchestration]] — sits above the bundler in a monorepo.

## Sources

- [[advanced-js-00-iifes-commonjs-es6-modules]] — Webpack as the canonical bundler example.
- [[js-commonjs]] — bundlers as the bridge that made CJS browser-loadable.
