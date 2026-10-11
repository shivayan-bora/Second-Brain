---
id: hooks-carry-their-provider-requirements
aliases: []
tags:
  - review-comments
  - react
  - tanstack-query
  - testing
creation date: 2026-10-06 23:20
modification date: Tuesday 6th October 2026 23:20:52
---

## The idea
Hooks like [[TanStack Query]]'s `useQuery` read a client from React context, so they need a `QueryClientProvider` ancestor and throw "No QueryClient set" without one. When a hook calls such a hook, the requirement travels upward. Every component that uses the hook, and every component that renders that component, now needs the provider too. This is true even when the query is `enabled: false` for that caller.

## Example
```tsx
// Before: a pure component, renders anywhere
function SelectBox({ options }: Props) { ... }

// After: it calls a shared hook that happens to use useQuery inside
function SelectBox(props: Props) {
  const { items } = useResolvedOptions(props); // calls useQuery even for static options
  ...
}

// Every test and app tree that renders SelectBox (directly or via a parent)
render(<SelectBox options={[...]} />);              // throws now
render(<SelectBox options={[...]} />, { wrapper }); // wrapper = QueryClientProvider
```

## Why it matters
The change looks local, but the failure lands far away: in another package's tests, in a Storybook story, or in an app shell without the provider. If CI skips those suites (draft or stacked PRs), the break only shows up after merge. Wrapping tests in a provider is the visible symptom of a contract change.

## Rule of thumb
When a shared component starts using a context-backed hook, treat the new provider as a breaking change. Grep every consumer and its tests, run the dependent packages' suites, and say it in the PR. If most callers never need the context, keep the pure part as a plain function that the hook wraps, so those callers can use it without the provider.
