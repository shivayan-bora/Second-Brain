---
title: "Query Invalidation"
pillar: software-engineering
type: concept
tags: [react, tanstack-query, cache, mutations]
status: stable
sources: ["[[video-tanstack-query-crash-course]]"]
created: 2026-06-09
updated: 2026-06-09
---

# Query Invalidation

## Definition

**Invalidation** marks one or more cached queries as stale, triggering a background refetch (for active subscribers) and forcing the next mount to re-fetch. It's the explicit "this cached data is no longer correct, please refresh" signal — typically called after a mutation succeeds.

## Why it matters

`staleTime` handles *passive* freshness (the clock decides). Invalidation handles *active* freshness (you decide — usually after a write). The pattern "mutate → invalidate → see updated data" is the canonical TanStack Query flow for any user action that changes server data.

## Mechanics

### The API

```tsx
const queryClient = useQueryClient();

// Invalidate a single query
queryClient.invalidateQueries({ queryKey: ['posts', postId] });

// Invalidate all queries starting with 'posts'
queryClient.invalidateQueries({ queryKey: ['posts'] });

// Invalidate everything (rare)
queryClient.invalidateQueries();
```

### Prefix matching

`['posts']` matches `['posts', 1]`, `['posts', 2]`, `['posts', { filter: 'recent' }]`, etc. This is why the hierarchical [[query-key]] shape (`['user', userId, 'posts']`) is so useful — you can invalidate a whole subtree with one call.

### After a mutation

The most common pattern:

```tsx
const { mutate } = useMutation({
  mutationFn: createPost,
  onSuccess: () => {
    queryClient.invalidateQueries({ queryKey: ['posts'] });
  },
});
```

After creating a post, invalidate the list of posts so the new one shows up.

### Specific overload — match exact key only

```tsx
queryClient.invalidateQueries({
  queryKey: ['posts', postId],
  exact: true,    // don't match descendants like ['posts', postId, 'comments']
});
```

### Async — await refetches

```tsx
await queryClient.invalidateQueries({ queryKey: ['posts'] });
// All matching active queries have refetched
```

Useful when you need to navigate or run subsequent code only after fresh data is in the cache.

## What invalidation actually does

Invalidation has two effects:

1. **Mark active queries as stale**, triggering immediate background refetches for any component currently subscribed.
2. **Mark inactive queries as stale**, so they re-fetch the next time a component subscribes (e.g., after navigation).

It does *not* clear the cached data — stale data is still shown until the refetch resolves. Use `queryClient.setQueryData(key, undefined)` to clear; use `queryClient.removeQueries({ queryKey })` to remove the entry entirely.

## Patterns

### Invalidate broadly after a mutation

```tsx
onSuccess: () => {
  queryClient.invalidateQueries({ queryKey: ['posts'] });
}
```

Safe default — slightly more refetching than necessary, but always correct.

### Surgical invalidation

```tsx
onSuccess: (newPost) => {
  queryClient.invalidateQueries({ queryKey: ['posts', 'list'] });
  queryClient.setQueryData(['posts', newPost.id], newPost);
}
```

Update the cache directly when you have the new data — no refetch needed for the individual post.

### Optimistic update + rollback

```tsx
useMutation({
  mutationFn: deletePost,
  onMutate: async (postId) => {
    await queryClient.cancelQueries({ queryKey: ['posts'] });
    const previous = queryClient.getQueryData(['posts']);
    queryClient.setQueryData(['posts'], (old) => old.filter(p => p.id !== postId));
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

`onMutate` snapshots and optimistically updates; `onError` rolls back; `onSettled` invalidates to reconcile with the server's final state.

## When NOT to use invalidation

- **`staleTime` would naturally cover the case.** If data refreshes every minute and the user is fine with up-to-a-minute lag, invalidation is overkill.
- **You can update the cache directly.** `setQueryData` is faster than invalidate-then-refetch when the mutation returns the canonical updated value.

## Related

- [[tanstack-query]] — the library.
- [[query-client]] — `invalidateQueries` is a client method.
- [[query-key]] — what invalidation matches against.
- [[query-cache-and-stale-time]] — passive freshness; invalidation is active.
- [[use-mutation]] — where invalidation is typically wired.

## Sources

- [[video-tanstack-query-crash-course]]
