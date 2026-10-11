---
id: expand-contract-api-field-migration
aliases:
  - parallel change
  - expand and contract
tags:
  - review-comments
  - api-design
  - graphql
  - deployment
creation date: 2026-10-01 10:27
modification date: Thursday 1st October 2026 10:27:14
---

## The idea
When a client and server deploy independently, renaming or replacing an API field has to happen in three steps, a pattern called [[expand-contract migration]] (or "parallel change"):
1. **Expand:** the server adds the new field and keeps serving the old one, fully populated.
2. **Migrate:** clients switch to the new field. They only ship once the expanded server is live everywhere they run.
3. **Contract:** after every client has moved, the server stops populating and then removes the old field.

[[GraphQL]] makes the order strict. The server validates the whole query document before executing it, so a client that selects a field the server doesn't know gets a validation error for the *entire* operation, not just a missing field. Marking a field `@deprecated` is only a hint. If the server also stops filling it (returns `null`) in the same change, existing clients silently lose data.

## Example
```graphql
type Detail {
  owners: [Owner] @deprecated(reason: "Use assignedOwners")  # still populated during migration
  assignedOwners: [AssignedOwner!]                           # new
}
```
```ts
// Client, shipped only after the server above is live everywhere:
const query = gql`query { detail { assignedOwners { name reasons } } }`;
```
Failure modes when the order slips:
- Client first: "Cannot query field assignedOwners" breaks the whole page (often straight into an error boundary).
- Server deprecates and nulls the old field before the client migrates: the UI renders empty with no error at all.

## Why it matters
Release branches, staged rollouts, canaries and customer-dedicated stacks mean "both PRs are merged" does not equal "both are deployed together". Getting the order wrong produces either a hard outage of the screen or a silent data gap. The silent gap is worse because nothing alerts.

## Rule of thumb
A client PR that selects a new field should name the server change it depends on and confirm it is deployed first. A server PR that deprecates a field should keep populating it until clients have migrated; stop populating only in the contract step.
