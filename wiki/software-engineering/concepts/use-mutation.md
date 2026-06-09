---
title: "useMutation"
pillar: software-engineering
type: concept
tags: [react, tanstack-query, hooks, mutations]
status: in-progress
sources: ["[[video-tanstack-query-crash-course]]"]
created: 2026-06-09
updated: 2026-06-09
---

# useMutation

## Definition

`useMutation` is TanStack Query's write-side hook — for POST/PUT/PATCH/DELETE-style operations. Unlike [[use-query|`useQuery`]], it doesn't auto-fetch on mount; it returns a `mutate()` function the caller invokes, and provides lifecycle callbacks (`onMutate`, `onSuccess`, `onError`, `onSettled`) for cache updates and side effects.

> **Status**: `in-progress` — the current sources reference `useMutation` and its callback shape but don't deeply walk through optimistic updates with worked examples. Will expand on re-ingest of later sources.

## Why it matters

Most TanStack Query codebases evolve in two phases: first you replace `useEffect` fetches with `useQuery`; then you replace fetch-then-setState writes with `useMutation`. The second phase is where the cache gets serious — you start using `onSuccess` to [[query-invalidation|invalidate]] queries after writes, which is the canonical "mutate then refresh" flow.

## Mechanics

### Minimal mutation

```tsx
const { mutate, isPending, error, data } = useMutation({
  mutationFn: createPost,
});

<button onClick={() => mutate({ title: 'Hello', body: '...' })}>
  Create
</button>
```

`mutationFn` takes the variables and returns a promise resolving to the server response.

### Lifecycle callbacks

```tsx
useMutation({
  mutationFn: createPost,
  onMutate: async (variables) => {
    // BEFORE the mutation runs. Common for optimistic updates.
    // Return value becomes `context` in later callbacks.
  },
  onSuccess: (data, variables, context) => {
    // AFTER successful mutation.
    // Most common spot for queryClient.invalidateQueries().
  },
  onError: (error, variables, context) => {
    // AFTER failed mutation. Roll back optimistic updates here.
  },
  onSettled: (data, error, variables, context) => {
    // AFTER either success or error.
    // Common spot for "always invalidate" to reconcile with server.
  },
});
```

### Canonical "mutate + invalidate" pattern

```tsx
const queryClient = useQueryClient();

const { mutate } = useMutation({
  mutationFn: createPost,
  onSuccess: () => {
    queryClient.invalidateQueries({ queryKey: ['posts'] });
  },
});
```

After the write succeeds, the posts list invalidates so the new post appears.

### Optimistic update pattern (sketch)

```tsx
useMutation({
  mutationFn: deletePost,
  onMutate: async (postId) => {
    await queryClient.cancelQueries({ queryKey: ['posts'] });
    const previous = queryClient.getQueryData(['posts']);
    queryClient.setQueryData(['posts'], (old) =>
      old.filter(p => p.id !== postId)
    );
    return { previous };
  },
  onError: (err, postId, context) => {
    queryClient.setQueryData(['posts'], context.previous);
  },
  onSettled: () => {
    queryClient.invalidateQueries({ queryKey: ['posts'] });
  },
});
```

- `onMutate` removes the post from the UI immediately, returns the previous snapshot.
- `onError` rolls back if the server rejects.
- `onSettled` re-invalidates to reconcile with the server's final state.

This is the **optimistic-updates** pattern. Worth its own page when sources go deeper.

## The return value

```ts
type UseMutationResult = {
  mutate: (variables) => void;              // fire-and-forget
  mutateAsync: (variables) => Promise<...>; // returns the promise
  isPending: boolean;                       // fetch in flight
  isError: boolean;
  isSuccess: boolean;
  data: TData | undefined;
  error: TError | null;
  reset: () => void;                        // clear state
};
```

- **`mutate`** — fire-and-forget; errors don't reject, they go to `onError`.
- **`mutateAsync`** — returns the promise so you can `await` it. Used when caller needs to act on the result before continuing (e.g., navigate after save).
- **`isPending`** — true while the mutation is in flight. Disable buttons with this.
- **`reset()`** — clears the mutation state (useful after the user dismisses an error toast).

## Common pitfalls

- **`mutationFn` returning `undefined`** — TanStack will treat as success but `data` will be `undefined`.
- **Side effects in `mutationFn`** — keep `mutationFn` pure (just the API call); put side effects in `onSuccess`/`onError`.
- **Forgetting to invalidate.** The mutation succeeds but the displayed list still shows old data.
- **Over-invalidating.** `queryClient.invalidateQueries()` with no key invalidates everything — overkill 99% of the time.

## Related

- [[tanstack-query]] — the library.
- [[query-client]] — where `invalidateQueries` lives.
- [[query-invalidation]] — the post-mutation refresh mechanism.
- [[use-query]] — read-side counterpart.

## Sources

- [[video-tanstack-query-crash-course]] — references mutations but doesn't deeply walk through optimistic updates with worked examples; this page will deepen on re-ingest of later sources.
