---
id: nested-route-redirects-run-parent-first
aliases: []
tags:
  - review-comments
  - react
  - routing
creation date: 2026-09-30 10:15
modification date: Wednesday 30th September 2026 14:53:00
---

## The idea
In nested routers like [[TanStack Router]], `beforeLoad` runs from the outermost matched route down to the innermost, and the first `throw redirect(...)` stops the chain. A child route's redirect never runs if its parent already redirected. A redirect built only from `params` also throws away the rest of the path and the query string.

## Example
```ts
// Trap: parent and child both redirect, only the parent ever runs,
// and /old/42/accounts?tab=x lands on /new/42 (tail and search lost)
beforeLoad: ({ params }) => { throw redirect({ to: '/new/$id', params }) }

// Better: one guard at the top route that rewrites the prefix of the full href
beforeLoad: ({ location }) => {
  if (location.href.startsWith(FROM)) {
    throw redirect({ href: TO + location.href.slice(FROM.length), replace: true })
  }
}
```

## Why it matters
Per-level redirects look symmetric and correct when you read them, but deep links silently land on the wrong page. Mocking `useParams` in tests hides this completely. Only a test that renders the real route tree with a memory history at a deep link and asserts the final `href` catches it.

A test that rebuilds a small route tree inside the test file, with the redirect logic re-typed inline, doesn't count. It proves the router library keeps `href` and search on redirect, but it never imports your routes, so reverting the real fix leaves it green. If mounting the real tree is too heavy, extract the path rewrite into a pure function, call it from the routes, and table-test that function:
```ts
export const swapPrefix = (href: string, from: string, to: string) =>
  href === from || href.startsWith(`${from}/`) || href.startsWith(`${from}?`)
    ? to + href.slice(from.length)
    : href

it.each([
  ['/old/42/accounts?f=1', '/new/42/accounts?f=1'],
  ['/old', '/new'],
])('rewrites %s to %s', (input, expected) => {
  expect(swapPrefix(input, '/old', '/new')).toBe(expected)
})
```

## Rule of thumb
Redirect once, as high as possible, on the full `location.href`. Test redirects through the real router or a pure helper the routes actually call, never through mocked hooks or a copied route tree. See [[Route Redirects]].
