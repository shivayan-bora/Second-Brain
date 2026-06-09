---
title: "Video — Zod"
pillar: software-engineering
type: summary
tags: [video, zod, typescript, validation, schema]
status: stable
source: "raw/videos/Zod.md"
created: 2026-06-09
updated: 2026-06-09
---

# Video — Zod

Wide-coverage Zod walkthrough. Covers schema primitives, object validation modes (default / `.partial()` / `.required()` / `.strict()`), `parse` vs `safeParse`, **`z.infer` for type derivation** (the schema-as-source-of-truth pattern), advanced shapes (`union`, `enum`, `literal`), the `z.input` vs `z.infer` distinction for transformed schemas, and `extend`/`merge`/`transform` for composition.

## TL;DR

- **Zod is runtime type-validation** that integrates with TypeScript. Schemas are values you build; `parse(input)` either returns typed data or throws. See [[zod]] and [[runtime-type-validation]].
- **`parse` vs `safeParse`**: `parse` throws on validation failure; `safeParse` returns `{ success: true, data } | { success: false, error }` — no exception. Pick based on whether you want to brick the caller or branch on it. See [[parse-vs-safe-parse]].
- **`type T = z.infer<typeof Schema>`** is the *killer feature*. Define the schema once; TypeScript's type and runtime validation share a single source of truth. See [[zod-schema-as-source-of-truth]].
- Schemas can transform (`.transform()`) and have defaults (`.default(18)`), which creates an **input/output type asymmetry**: use `z.input<typeof S>` for the pre-validation shape and `z.infer<typeof S>` for the post-validation shape.
- **Object modes**: default strips unknown keys; `.strict()` errors on unknowns; `.partial()` makes all fields optional; `.required()` is the inverse.
- **Composition**: `extend`, `merge`, factoring shared fields into named schemas (e.g., `ObjectWithId.extend({...})`).

## Key takeaways

- Zod sits at **system boundaries** — API responses, form inputs, environment variables, anywhere data crosses from "I trust this" to "I don't." See [[runtime-type-validation]].
- The schema-as-source-of-truth pattern is what makes Zod different from runtime validators like Joi: you don't maintain a type alongside the schema; you derive it.
- Schema composition (`extend`/`merge`) maps cleanly to mature DB-schema/IDL patterns — `Id` as a shared type, `ObjectWithId` as a base.
- **`transform`** at the schema or field level lets validation also reshape data — a `Form` schema can take `keywords?: string[]` input and emit `keywords: string[]` output (via `.default([])`). The dual-type shape (`z.input` vs `z.infer`) is how TS surfaces this.

## Notable passages

> "It's an extremely common pattern to define all your types in the form of Zod schema which will act as the source of truth. You can then derive all the necessary types using `z.infer<T>` and use them in the code for type safety."

> "Zod ignores keys which aren't present in its schema." (default behavior; `.strict()` opts into error-on-unknown).

## Notable transcription errors in the raw

- `z.number()min(18)` should be `z.number().min(18)` — missing `.` (line 96 of raw).
- `z.literal(['open', 'close'])` is not valid — should be `z.enum(['open', 'close'])` or `z.union([z.literal('open'), z.literal('close')])` (line 300 of raw).
- Flagged here because the raw is read-only; future re-ingest could fix.

## Open questions

- Zod 4 added bigger performance improvements and an `arktype`-style speedup. The video predates this — worth a follow-up source.
- Error messages from Zod's default `parse` failure are JSON-ish; for user-facing form errors you'd typically map them. The video doesn't cover this.
- How does Zod compare to **ArkType** (faster runtime, more TS-native syntax) and **Valibot** (modular, tree-shakeable)? The video presents Zod in isolation.

## Cross-references

- Concepts: [[zod]], [[runtime-type-validation]], [[zod-schema-as-source-of-truth]], [[parse-vs-safe-parse]].
- TS bridges: [[ts-vs-js]], [[ts-compiler-tsc]], [[react-typescript]].

## Source

- `raw/videos/Zod.md`
