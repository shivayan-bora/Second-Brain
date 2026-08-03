---
title: "Zod"
pillar: software-engineering
type: concept
tags: [typescript, validation, schema, zod, runtime-types]
status: stable
sources: ["[[video-zod]]"]
created: 2026-06-09
updated: 2026-06-09
---

# Zod

## Definition

Zod is a TypeScript-first runtime schema validation library. You declare schemas with chained builder calls (`z.object({ name: z.string() })`), validate values at runtime (`.parse()` / `.safeParse()`), and **derive static TypeScript types from the same schemas** (`z.infer<typeof S>`). Schema and type stay in sync because they're literally the same value.

## Why it matters

TypeScript types are erased at runtime. The compiler doesn't help when an API returns the wrong shape, when a form field is blank, or when a config file is malformed. Zod sits at those boundaries, validating data on entry and producing typed values on exit — and the type definition is the validator itself.

## Mechanics

### Building schemas

```ts
import z from "zod";

const UserSchema = z.object({
  name: z.string(),
  age: z.number().min(18).max(120).default(18),
  isCool: z.boolean(),
  friends: z.array(z.string()),
  coordinates: z.object({
    lat: z.number(),
    lon: z.number(),
  }),
});
```

Primitives (`string`, `number`, `boolean`, `null`, `undefined`), arrays (`z.array(T)`), objects (`z.object({...})`), unions (`z.union([...])` or `.or()`), literals (`z.literal('open')`), enums (`z.enum(['open', 'close'])`), and structural validators (`z.email()`, `z.url()`, `z.uuid()`, `z.date()`).

### Validating

```ts
const value = { ... };

UserSchema.parse(value);       // throws ZodError on failure
UserSchema.safeParse(value);   // returns { success, data | error }
```

See [[parse-vs-safe-parse]] for when to use which.

### Deriving types

```ts
type User = z.infer<typeof UserSchema>;
```

The type tracks the schema. Add a field to the schema → the type updates. See [[zod-schema-as-source-of-truth]].

### Object validation modes

| Mode | Behaviour |
|---|---|
| Default | Unknown keys are stripped from the parsed output. |
| `.strict()` | Unknown keys cause a validation error. |
| `.passthrough()` | Unknown keys are kept (not covered in the source). |
| `.partial()` | All fields become optional. |
| `.required()` | All fields become required (inverse of `.partial()`). |

### Composition

```ts
const ObjectWithId = z.object({ id: z.string().uuid() });

const User    = ObjectWithId.extend({ name: z.string() });
const Post    = ObjectWithId.extend({ title: z.string(), body: z.string() });
const Comment = ObjectWithId.extend({ text: z.string() });
```

`.extend()` adds fields; `.merge()` combines two object schemas (use when two distinct schemas are being combined).

### Transforming

```ts
const Form = z.object({
  repoName: z.string(),
  keywords: z.array(z.string()).default([]),
});

// Input/output diverge because of .default():
type FormInput  = z.input<typeof Form>;   // keywords?: string[] | undefined
type FormOutput = z.infer<typeof Form>;   // keywords: string[]
```

`.transform()` reshapes during validation; `.default()` fills missing values. Both create the input/output asymmetry.

## When to reach for Zod

- **API response validation** — your client doesn't trust the server; parse on receipt.
- **Form input** — type the form schema once, validate on submit, derive form types from it.
- **Environment variables** — `EnvSchema.parse(process.env)` to fail fast at startup.
- **External config** (YAML, JSON files) — validate before the app touches the values.
- **Cross-boundary calls in monorepos** — even within one team, schemas at module boundaries catch drift.

## When NOT to use Zod

- Pure internal code with no untrusted boundary — TypeScript alone is fine.
- Hot paths where parsing overhead matters — Zod is fast but not free; pre-validate or use lighter alternatives (ArkType, Valibot) if you measure cost.

## Related

- [[runtime-type-validation]] — the broader category Zod represents.
- [[zod-schema-as-source-of-truth]] — the `z.infer` pattern that makes Zod different.
- [[parse-vs-safe-parse]] — Zod's two error-handling modes.
- [[ts-vs-js]], [[ts-compiler-tsc]] — why TS alone can't cover runtime.

## Sources

- [[video-zod]]
