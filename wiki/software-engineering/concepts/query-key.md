---
title: "Query Key"
pillar: software-engineering
type: concept
tags: [react, tanstack-query, cache, identity]
status: stable
sources: ["[[query-gg-00-laying-the-foundation]]", "[[project-tanstack-query-basic]]", "[[video-tanstack-query-crash-course]]"]
created: 2026-06-09
updated: 2026-06-09
---

# Query Key

## Definition

A **query key** is the unique identifier of a query in TanStack Query's cache. It's an array of values that uniquely names "what data this is." Same key, same cache entry — concurrent requests dedup, multiple subscribers share, refetches replace.

```tsx
useQuery({
  queryKey: ['comments', postId],
  queryFn: () => getComments(postId),
});
```

## Why it matters

The key is **identity**, not just a label. Getting it wrong manifests as silent cache corruption: stale data shown for the wrong record, refetches that don't fire, components that "magically" share state they shouldn't. For staff-level review of TanStack Query code, query key shape is the first thing to inspect.

## The two rules

### 1. Same logical resource → same key shape

Always use the same shape across the app for the same kind of resource. If `['comments', postId]` fetches comments in one place, *every* place that fetches comments uses `['comments', someId]`. This is what enables [[query-invalidation|`invalidateQueries(['comments'])`]] to hit every comment query in one call.

### 2. Include all inputs that change the response

If the response depends on `postId`, `postId` is in the key. If it depends on a filter, the filter is in the key. Missing inputs = wrong data shown:

```tsx
// ❌ Wrong — different postIds share one cache entry
useQuery({
  queryKey: ['comments'],
  queryFn: () => getComments(postId),  // postId varies but not in key
});

// ✅ Right
useQuery({
  queryKey: ['comments', postId],
  queryFn: () => getComments(postId),
});
```

## Common shapes

### Single resource

```tsx
['user', userId]
['post', postId]
```

### Resource collection with filters

```tsx
['posts', { author: 'shivayan', sortBy: 'date' }]
['users', { role: 'admin', page: 2 }]
```

Filter objects are deep-equal-compared by TanStack Query, so two object literals with the same shape hit the same cache entry.

### Hierarchical / scoped

```tsx
['user', userId, 'posts']            // user's posts
['user', userId, 'posts', postId]    // a specific post under a user
```

This shape pairs well with prefix-matching invalidation: `invalidateQueries(['user', userId])` invalidates everything under that user.

## What goes in the key

- ✅ Any input that changes the response: IDs, filters, sort, pagination.
- ✅ Logical scope: `'comments'`, `'user'`, `'product'`.
- ❌ The fetcher function (it's static; not identifying).
- ❌ Auth tokens (handled at the HTTP layer; don't fragment cache per token).
- ❌ Random nonces or `Math.random()` (defeats caching entirely).

## Key-as-identity vs key-as-deps

For `useEffect`, the deps array tells React *when to re-run*. For `useQuery`, the key tells TanStack Query *what data this is*. Subtle but important:

- React deps: changing causes effect to re-run.
- TanStack key: changing means *this is a different query* — different cache entry, possibly different data.

## Examples

```tsx
// Pokemon by ID
useQuery({
  queryKey: ['pokemon', id],
  queryFn: () => fetch(`/pokemon/${id}`).then(r => r.json()),
});

// All products (collection)
useQuery({
  queryKey: ['products'],
  queryFn: fetchAllProducts,
});

// Filtered products
useQuery({
  queryKey: ['products', { category, page }],
  queryFn: () => fetchProducts({ category, page }),
});

// Auth-scoped — typically don't include token in key
useQuery({
  queryKey: ['me'],
  queryFn: fetchCurrentUser,    // axios interceptor adds token
});
```

## Related

- [[tanstack-query]] — the library.
- [[use-query]] — the hook that takes the key.
- [[query-invalidation]] — invalidation uses the key (or prefix).
- [[query-client]] — the cache the key indexes into.

## Sources

- [[query-gg-00-laying-the-foundation]]
- [[project-tanstack-query-basic]]
- [[video-tanstack-query-crash-course]]
