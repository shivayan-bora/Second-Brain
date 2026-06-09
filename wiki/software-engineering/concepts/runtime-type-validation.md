---
title: "Runtime Type Validation"
pillar: software-engineering
type: concept
tags: [typescript, validation, schemas, boundaries]
status: stable
sources: ["[[video-zod]]"]
created: 2026-06-09
updated: 2026-06-09
---

# Runtime Type Validation

## Definition

**Runtime type validation** is the practice of checking that a value has an expected shape *at runtime*, typically at a system boundary (API response, form input, environment variable, file). It complements static typing — TypeScript catches errors during compile, validators catch them when bad data actually arrives.

## Why it matters

TypeScript types are **erased at runtime**. `function getUser(id: string): User` is a compile-time contract; nothing at runtime checks that the fetched response is a `User`. If the API returns a different shape, your code crashes far from the cause. Runtime validation closes this gap at system boundaries — and lets you derive the static type from the validator, keeping them in sync.

## The category

| Library | Approach | Notes |
|---|---|---|
| **[[zod\|Zod]]** | TS-first chained schemas | Most popular; `z.infer` for type derivation |
| **Yup** | TS-second, similar API | Predates Zod; common in Formik stack |
| **io-ts** | Pure functional / fp-ts style | Steeper learning curve |
| **ArkType** | TS-native syntax | Fastest runtime; newer |
| **Valibot** | Modular, tree-shakeable | Bundle-size-focused |
| **Joi** | JS-first; no TS type derivation | Old guard; Node-server world |
| **Ajv** | JSON Schema validator | Use when you have to *exchange* JSON Schema (e.g., OpenAPI) |

## Where to validate

The pattern is **"validate at the boundary, trust inside."**

```
[ Untrusted Boundary ]               [ Trusted Inside ]

API response   ───validate───►       typed value used everywhere
Form input     ───validate───►       typed model passed to UI
env vars       ───validate───►       typed config struct
JSON config    ───validate───►       typed settings object
DB rows        ───validate───►       typed entities (sometimes)
```

Inside the trust boundary, TypeScript types alone are enough. Validating internal function calls is overkill and noise.

## What validation is NOT

- **Authentication / authorization** — separate concern. A validated payload from an unauthenticated user is still untrusted.
- **Business-rule validation** — "is this user allowed to do X" is logic, not shape. Don't conflate.
- **Sanitization** — runtime validators check shape, not safety. SQL injection / XSS prevention is a different layer.

## Trade-offs

- **Pro:** runtime safety at system boundaries.
- **Pro:** single source of truth (schema → type derivation).
- **Pro:** declarative — schema reads as documentation.
- **Con:** runtime cost (small but real on hot paths).
- **Con:** another dependency.
- **Con:** schemas duplicate the static type info if you don't use derivation — easy to drift.

## Related

- [[zod]] — the most common implementation in the TS ecosystem.
- [[zod-schema-as-source-of-truth]] — the type-derivation idiom that makes the dual-purpose schema work.
- [[parse-vs-safe-parse]] — handling validation failures.
- [[ts-vs-js]] — why static types alone aren't enough.

## Sources

- [[video-zod]] — Zod-shaped framing of the category.
