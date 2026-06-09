---
title: "Project — TanStack Query Basic"
pillar: software-engineering
type: summary
tags: [project, react, tanstack-query, vite, typescript, tailwind]
status: stable
source: "raw/projects/tanstack-query basic project.md"
created: 2026-06-09
updated: 2026-06-09
---

# Project — TanStack Query Basic

Hands-on minimal project wiring up Vite + React + TS + Tailwind + ESLint + Prettier + TanStack Query + Axios. Demonstrates the canonical setup and a single `useQuery` call against the dummyjson products API.

## TL;DR

- **Stack**: Vite + React (no Compiler) + TypeScript + Tailwind + Axios + TanStack Query.
- **Tooling**: ESLint flat config (`eslint.config.ts` + `eslint.config.js`) + Prettier + `eslint-config-prettier/flat` to prevent rule conflicts.
- **TanStack setup**: `new QueryClient()` instantiated outside React; `<QueryClientProvider client={queryClient}>` wrapping `<App />` at the root.
- **First query**: `useQuery({ queryKey: ['products'], queryFn: fetchProducts })` returns `{ data, isLoading, isError, error }`.
- The `queryFn` is yours — TanStack Query doesn't care if you use `fetch`, `axios`, `ky`, or anything else; just give it an async function.

## Key takeaways

- **`QueryClient` lives outside React** — instantiated as a module-level constant, not in component body. Putting it in `useState` would recreate the cache on every render.
- **Two destructured booleans**: `isLoading` and `isError`. (The crash-course video also surfaces `isPending`, `isFetching`, `isSuccess` — worth disambiguating later.)
- **Error type-cast**: `(error as Error).message` — TanStack Query's `error` is typed as `Error | null` by default; you can override with the generic param of `useQuery`.
- **Render branches**: early-return for `isLoading` and `isError` before rendering `data` — handles the "data might be undefined" TS narrowing.

## Notable patterns

```tsx
const { data, isLoading, isError, error } = useQuery({
  queryKey: ['products'],
  queryFn: fetchProducts,
});

if (isLoading) return <p>Loading...</p>;
if (isError) return <p>Error: {(error as Error).message}</p>;
return <ProductList products={data?.products ?? []} />;
```

The early-return pattern is idiomatic for `useQuery` — it both handles the visual state and narrows `data`'s type from possibly-undefined.

## Open questions

- The project sets up Axios but uses it only for `axios.get`; what's the case for axios over native `fetch` in TanStack Query? (Interceptors, request cancellation tokens? Or just team preference?)
- ESLint flat config + TS dual file (`eslint.config.ts` + `eslint.config.js`) is a recent setup — does this make sense long-term, or is it a TS-config transitional state?
- Project status flagged "in-progress" — likely Stage 4+ (mutations, optimistic updates, invalidation) come next.

## Cross-references

- Companion: [[query-gg-00-laying-the-foundation]] (the why), [[video-tanstack-query-crash-course]] (the broader API).
- Concepts: [[tanstack-query]], [[query-client]], [[use-query]], [[query-key]].
- Related setup: [[utility-first-css]] (Tailwind setup mirrors), [[js-modules-history]] (flat-config ESLint is JS-modules-aware).

## Source

- `raw/projects/tanstack-query basic project.md`
