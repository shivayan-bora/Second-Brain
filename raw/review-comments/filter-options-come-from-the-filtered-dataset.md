---
id: filter-options-come-from-the-filtered-dataset
aliases:
  - facet values must match the list
tags:
  - review-comments
  - filtering
  - api-design
creation date: 2026-10-07 14:58
modification date: Thursday 8th October 2026 19:45:10
---

## The idea
A filter dropdown (a [[Faceted Search]] facet or a typeahead) is only useful if its options are the values that actually occur in the list it filters. When the options come from some other endpoint or dataset ("all apps", "all users", another page's option source), two things go wrong. Options that match nothing show up, and values that do exist in the list never show up. The second one is worse, because the user can't filter by them at all and has no way to tell.

## Example
```ts
// A list of API keys, each tagged with the app it belongs to.
// Trap: options come from a generic "apps" source that another screen
// scoped to login providers only.
const appFilter = {
  field: 'appName',
  options: () => fetchOptions({ source: 'login-providers-page', field: 'appName' }),
}

// Better: ask for distinct values of the same field, on the same collection
const appFilter = {
  field: 'appName',
  options: (search: string) =>
    fetchDistinctValues({ collection: 'apiKeys', field: 'appName', search }),
}
```
If the server picks the option set based on a "context" or "scope" parameter, that parameter is part of the contract. Reusing another screen's scope also reuses its rules: category limits, hidden items, permissions.

## Why it matters
Mock-backed tests can't catch this, because the mock returns whatever options the fixture lists. The bug only shows up against real data, often on the customers with the most varied data. It also couples two screens: a change to the other screen's option rules silently changes this one.

## When a hidden value gets a visible name
A common way values go missing from a facet is on purpose: a sentinel like `Unknown` or `Unavailable` is stripped from the options because the table used to show it as a blank or a dash. If the table later starts rendering that sentinel as a real word, the stripping becomes a bug. The user can read "Unavailable" in a cell but finds no "Unavailable" option.

```ts
// Written when 'Unavailable' rendered as a dash
const options = values.filter((v) => v !== 'Unavailable').map(toOption)

// After the cell starts showing the word, either expose it...
const options = values.map(toOption)
// ...or say why it can't be filtered
// The API rejects filtering on Unavailable, so it stays out of the options.
```

## Rule of thumb
Derive filter options from the same collection and field the list query filters on. If the backend scopes options by a context parameter, give each list its own context instead of borrowing a neighbor's, and check the dropdown against real data once.
