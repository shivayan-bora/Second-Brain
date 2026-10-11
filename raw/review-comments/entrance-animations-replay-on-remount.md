---
id: entrance-animations-replay-on-remount
aliases:
  - skip the fade when data is cached
tags:
  - review-comments
  - react
  - animation
  - css
creation date: 2026-10-07 18:00
modification date: Wednesday 7th October 2026 18:00:13
---

## The idea
A CSS entrance animation (`animation: fade-in 300ms`) runs whenever its element is inserted into the DOM. In a React app that means it runs on every mount. Navigating away and back, switching tabs that render their own copy of a widget, or a list re-keying its items all count as a fresh insert. When the data comes from a client cache (TanStack Query, SWR), the content can be ready on the very first frame, and a fade then just looks like a flicker.

The fix is to decide at mount time whether the content actually arrived late. Snapshot the loading flag in a `useState` initializer. It runs once per mount, and the value never changes for the life of that instance:

## Example
```tsx
function Insights({ ids }) {
  const query = useQuery({ queryKey: ['insights', ids], queryFn: () => fetchInsights(ids) })
  // Decided once per mount: true only if this mount had to wait for the data.
  const [animateIn] = useState(query.isLoading)

  if (query.isLoading) return <Skeleton />
  return query.data.map((item) => (
    <Card key={item.id} className={animateIn ? 'motion-safe:animate-fade-in' : undefined} item={item} />
  ))
}
```
Things to know:
- With a warm but stale cache, a background refetch keeps `isLoading` false (TanStack v4 `status: 'success'`), so there is no fade, which is what you want.
- The snapshot is per mount, not per query key. If the key changes while the component stays mounted, the new data uses the first render's answer. Either accept that and write a comment, or give the component a `key` from the query inputs so it remounts and decides again (see [[reset-state-with-a-key]]).
- Adding the animation class to an element that is already on screen also starts the animation. So "turn it on later" with a derived value like `dataUpdatedAt > mountedAt` can replay the fade on an identical background refetch.
- In TanStack v4, `isLoading` is also `true` for a disabled query with no data. In v5 it is `isPending && isFetching`, so a disabled query reports `false`. Check which version you're on before relying on it.
- Gate it on reduced motion as well (`motion-safe:` or `motion-reduce:animate-none`), which is separate from the cache question.

## Why it matters
Entrance motion is supposed to say "this just arrived". When it plays on content the user has already seen, it says the opposite and makes navigation feel slower. Unit tests in jsdom won't notice, because the class is there in both cases and nothing measures time.

## Rule of thumb
Animate content in only when this mount actually waited for it. Snapshot "was loading" once with `useState(isLoading)`, and test both paths: a cold mount fades, a remount on a warm cache doesn't.
