---
title: "useSuspenseQuery — Suspense Mode"
pillar: software-engineering
type: concept
tags: [react, tanstack-query, suspense, hooks]
status: stable
sources: ["[[video-tanstack-query-crash-course]]"]
created: 2026-06-09
updated: 2026-06-09
---

# useSuspenseQuery — Suspense Mode

## Definition

`useSuspenseQuery` is TanStack Query's React-Suspense variant of `useQuery`. Same API surface, **but**: during the first fetch, the component **suspends** instead of returning `isLoading: true`. The `data` field is guaranteed defined when the component renders. Loading state is hoisted to the nearest `<Suspense>` boundary.

## Why it matters

`useQuery` returns `data: T | undefined`, which forces you to early-return on `isLoading` to narrow the type. `useSuspenseQuery` removes this ceremony — `data` is `T`, full stop — at the cost of integrating with React's Suspense model. For modern React (post-18) with `<Suspense>` already in your tree, it's the cleaner API.

## Mechanics

### Setup — wrap in `<Suspense>`

```tsx
import { Suspense } from 'react';

function App() {
  return (
    <Suspense fallback={<div>Loading...</div>}>
      <Card />
    </Suspense>
  );
}
```

The `<Suspense>` boundary catches the suspension and renders the fallback.

### The hook

```tsx
const { data, error, refetch } = useSuspenseQuery({
  queryKey: ['comments', id],
  queryFn: () => getComments(id),
});

// data is TData — never undefined
return <CommentList comments={data} />;
```

No `isLoading` to handle. No early-return for the spinner. The Suspense boundary handles the visual loading state.

## What's different from `useQuery`

| | `useQuery` | `useSuspenseQuery` |
|---|---|---|
| `data` type | `T \| undefined` | `T` |
| Loading state | `isLoading: true`, render the spinner inline | Component suspends; nearest `<Suspense>` shows fallback |
| `enabled` option | Yes | **No** (mutually exclusive with suspension) |
| Error handling | `isError` / `error` returned | `error` returned + thrown to nearest `<ErrorBoundary>` |
| Suspense integration | Optional | Required |

The two big constraints: **no `enabled`** (the data must always fetch on mount; conditional fetching breaks suspension semantics), and **errors throw** (so you need an `<ErrorBoundary>` upstream).

## When to use `useSuspenseQuery`

- **You already use `<Suspense>` boundaries** in your tree (e.g., for code splitting, `React.lazy`).
- **You want to centralize loading UI** at a parent boundary rather than per-component.
- **Type safety on `data` matters** — eliminating the `undefined` narrowing is a real DX win.
- **Streaming SSR / RSC integration** — Suspense is the React-native model for streaming.

## When to use plain `useQuery`

- **You need `enabled`** for conditional fetching (depends on user-input, depends on auth state).
- **You want inline loading states** (per-component spinners).
- **You don't have `<Suspense>` boundaries yet** and don't want to add them.

## With `queryOptions`

Suspense queries compose with the [[use-query|`queryOptions` factory]] just like regular queries:

```ts
export function commentsOptions(id: number) {
  return queryOptions({
    queryKey: ['comments', id],
    queryFn: () => getComments(id),
  });
}
```

```tsx
const { data } = useSuspenseQuery(commentsOptions(id));
```

The same `queryOptions` work for both `useQuery` and `useSuspenseQuery`.

## Error handling

```tsx
<ErrorBoundary fallback={<ErrorView />}>
  <Suspense fallback={<Spinner />}>
    <Component />     {/* uses useSuspenseQuery */}
  </Suspense>
</ErrorBoundary>
```

- `<Suspense>` catches loading suspensions.
- `<ErrorBoundary>` catches thrown errors.
- The `error` field on the hook's return is still populated (for inline rendering after recovery), but errors *also* throw to the boundary.

## Related

- [[tanstack-query]] — the library.
- [[use-query]] — the non-suspense counterpart.
- [[query-key]], [[query-client]] — same machinery underneath.
- [[react-hooks]] — Suspense is React's data-loading model.

## Sources

- [[video-tanstack-query-crash-course]]
