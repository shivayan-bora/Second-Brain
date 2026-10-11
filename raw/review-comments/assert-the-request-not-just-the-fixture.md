---
id: assert-the-request-not-just-the-fixture
aliases:
  - a mock that ignores its input can't test the request
tags:
  - review-comments
  - testing
  - data-fetching
creation date: 2026-10-07 12:43
modification date: Wednesday 7th October 2026 12:43:10
---

## The idea
A network mock (MSW, `fetch` stub, fake API client) that returns the same canned response whatever it receives only lets you test what the UI does *with* the data. It can't catch bugs in how the request was *built*: wrong filters, missing parameters, two fields swapped. If the interesting logic of a feature is "which question do we ask the server", that logic needs a test that looks at the question, either by making the request builder a pure function or by asserting on what the mock received.

## Example
```ts
// Trap: the handler ignores variables, so this passes even if the
// "overdue" card forgets to include the user's filters
server.use(
  graphql.query('getCounts', () => HttpResponse.json({ data: { total: 10, overdue: 3 } })),
)
render(<Counts filters={[statusFilter]} />)
expect(await screen.findByText('3')).toBeInTheDocument()

// Better (a): pull the builder out and test it directly
export const buildCountVariables = (filters: Filter[]) => ({
  total: { filters },
  overdue: { filters: [...filters, overdueFilter] },
})

it('should add the page filters to every count', () => {
  const variables = buildCountVariables([statusFilter])
  expect(variables.total.filters).toEqual([statusFilter])
  expect(variables.overdue.filters).toEqual([statusFilter, overdueFilter])
})

// Better (b): capture what the mock received
let received: unknown
server.use(
  graphql.query('getCounts', ({ variables }) => {
    received = variables
    return HttpResponse.json({ data: { total: 10, overdue: 3 } })
  }),
)
render(<Counts filters={[statusFilter]} />)
await screen.findByText('3')
expect(received).toEqual(buildExpectedVariables())
```

## Why it matters
Request-building bugs don't crash anything. The page renders fine and shows a plausible but wrong number, and every test stays green because the fixture always answers correctly. These bugs are usually found by a user comparing two numbers that should match. Dashboards and summary counts are the classic case, because each card is "the same query plus one extra filter", which is easy to get subtly wrong.

## Rule of thumb
Ask "would this test fail if I sent the wrong request?" If not, test the request builder as a pure function, or assert on the variables the mock received. Prefer the pure function: it's faster and needs no network setup. See [[Mock Service Worker]], [[Pure Functions]].
