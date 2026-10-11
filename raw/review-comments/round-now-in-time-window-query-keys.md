---
id: round-now-in-time-window-query-keys
aliases:
  - time-relative query params
tags:
  - review-comments
  - tanstack-query
  - dates
creation date: 2026-10-06 23:11
modification date: Tuesday 6th October 2026 23:11:16
---

## The idea
A query like "expiring in the next 30 days" needs `now`. If you compute `new Date().toISOString()` during render and put it in the query params, the key changes every millisecond. Each re-render then starts a new fetch and throws away the cache. Round `now` to a boundary (minute, hour, start of day) so the key only changes when the window really moves. The rounding choice is also a product choice: it decides what lands on each edge of the window.

## Example
```ts
import { addDays, startOfDay, startOfHour, endOfDay } from 'date-fns'

// Trap: new key on every render
const from = new Date().toISOString()

// Stable for the day, but includes items that expired earlier today
const today = startOfDay(new Date())
const window1 = [today.toISOString(), addDays(today, 30).toISOString()]

// Stable for the hour, excludes most already-expired items, full last day included
const hour = startOfHour(new Date())
const window2 = [hour.toISOString(), endOfDay(addDays(hour, 30)).toISOString()]
```
`startOfDay` uses the browser's timezone. `toISOString()` then converts that to UTC, so users in different timezones send different windows. That's usually right ("my today"), but it's worth knowing.

## Why it matters
An unrounded `now` causes refetch loops and a cache that never hits. A carelessly rounded one quietly moves the boundaries: "within 30 days" becomes "29.4 days, plus a few hours of already-expired items". Users notice when they compare the card against the date column. Absolute dates put in a URL also freeze the window, so a link shared tomorrow shows yesterday's window.

## Rule of thumb
Round `now` before it enters a query key. Pick the rounding per edge on purpose, and write one comment saying what each edge includes.
