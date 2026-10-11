---
id: keep-old-urls-resolving
aliases:
  - Cool URIs Dont Change
tags:
  - review-comments
  - routing
  - web
creation date: 2026-10-07 20:46
modification date: Friday 9th October 2026 12:52:23
---

## The idea
Once a URL has been shown in the address bar, it is public: people bookmark it, paste it into chat and tickets, and emails or other systems link to it. Moving a page is fine, but the old URL should keep working as a redirect to the new one, for as long as anyone might still hold it. In a SPA the alias usually lives in a route table or a mapping used for redirects. Watch out for tables read in both directions: an entry can look unused for building links while still being the only thing that resolves an old link.

## Example
```ts
// Trap: the page moved back to /settings/billing, so the temporary alias is "unused"
const ALIASES = [
  // ['/account/billing', '/settings/billing'],  // deleted
]
// /account/billing now hits the catch-all and lands on the home page

// Better: keep resolving the old URL, stop generating it
const ALIASES = [
  // Old links only: nothing links here any more. Remove after <date or ticket>.
  ['/account/billing', '/settings/billing'],
]
```
A redirect that lands on the wrong page with no message is worse than a 404, because nobody reports it.

A catch-all route doesn't save you either. A common setup is one specific alias per page plus a catch-all that rewrites the URL prefix (`/new-section/...` to `/old-section/...`). Rename the specific alias and the old URL now hits the catch-all, which rewrites only the prefix and produces a path that never existed (`/old-section/all-items`), so the user lands on not-found. Check what the fallback does with the exact old URL before deleting an alias.

## Why it matters
Removing an alias breaks links you can't see: bookmarks, shared links, links in old tickets and docs. The failure is silent, so it shows up as "this link is broken" weeks later. You'll hit it whenever a page is renamed, moved behind a flag, or a temporary URL scheme is rolled back.

## Rule of thumb
When you stop generating a URL, keep resolving it. Remove the redirect later, on purpose, once nobody can still hold the link. See [[Route Redirects]] and [[url-state-round-trip]].
