---
title: "Dynamic Imports — `import()`"
pillar: software-engineering
type: concept
tags: [javascript, modules, esm, code-splitting, lazy-loading, react]
status: stable
sources: ["[[article-js-es6-modules-vs-commonjs]]", "[[advanced-js-00-iifes-commonjs-es6-modules]]"]
created: 2026-06-09
updated: 2026-06-09
---

# Dynamic Imports — `import()`

## Definition

`import("./path")` is the **function form** of ESM imports: it returns a `Promise` that resolves to the module namespace. Unlike static `import` (a top-level declaration that must be analyzable at build time), `import()` can appear anywhere a function call can — inside an `if`, a click handler, a route component.

## Why it matters

Dynamic import is how you get **code splitting** out of ESM. Heavy, rarely-used components (a date picker, a rich-text editor, an admin-only panel) load only when actually needed, keeping the initial bundle small. It's the bridge between [[js-es-modules|ESM's static-by-default model]] and the real-world need for runtime-conditional loading.

## Mechanics

```ts
// dynamic — returns a Promise
const mod = await import("./heavy-module");
mod.doExpensiveThing();
```

### Combined with React.lazy

```tsx
const DatePicker = React.lazy(() =>
  import("@acme/ui/date-picker").then((mod) => ({ default: mod.DatePicker }))
);
```

- `React.lazy` expects a default export, so when the module uses named exports the inline `.then(...)` reshapes the value.
- Wrap consumers in `<Suspense fallback={...}>` to handle the loading state.

### Just for conditional loading (no React)

```ts
if (process.env.NODE_ENV === "development") {
  const { installDevTools } = await import("./dev-tools");
  installDevTools();
}
```

This is the ESM equivalent of CJS's conditional `require()`. The dev-tools code only ships in the dev bundle (assuming the bundler eliminates the branch in prod).

## What you get

- **Code splitting.** Bundlers (Vite, Webpack, esbuild) treat each `import()` call as a chunk boundary. The chunks load on demand.
- **Network parallelism.** Multiple `import()`s in flight resolve concurrently.
- **Bundle hashing** survives because each chunk gets its own content hash.

## Pitfalls

- **Don't dynamic-import everything.** Each chunk is a separate HTTP request — over-splitting hurts latency.
- **Prefetch when you can.** Bundlers expose hints (`/* webpackPrefetch: true */`, `<link rel="modulepreload">`) so chunks are warmed up before the user clicks.
- **Server-side rendering interaction.** With SSR, dynamic imports may need to be awaited up front or use framework-specific shapes (Next.js `dynamic()`, Remix lazy routes).

## Related

- [[js-es-modules]] — `import()` complements the static `import` declaration.
- [[tree-shaking]] — orthogonal but combines well: each chunk is independently tree-shaken.
- [[react-hooks]] — `React.lazy` + `<Suspense>` is the React-flavored consumer of dynamic imports.

## Sources

- [[article-js-es6-modules-vs-commonjs]] — `React.lazy` recipe, design-system framing for heavy components.
- [[advanced-js-00-iifes-commonjs-es6-modules]] — mentions ESM's static constraint as the motivation for `import()`'s function form.
