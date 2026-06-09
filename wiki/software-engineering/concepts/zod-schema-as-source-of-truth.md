---
title: "Zod — Schema as Source of Truth (`z.infer`, `z.input`)"
pillar: software-engineering
type: concept
tags: [zod, typescript, schema, types]
status: stable
sources: ["[[video-zod]]"]
created: 2026-06-09
updated: 2026-06-09
---

# Zod — Schema as Source of Truth (`z.infer`, `z.input`)

## Definition

A pattern where the Zod schema is the **single declaration** of a shape, and the static TypeScript type is **derived** from it via `z.infer<typeof Schema>`. Schema and type cannot drift — they're literally the same value, viewed through two lenses.

## Why it matters

Without this pattern, you maintain a TypeScript `type` and a Zod schema side by side. They drift; a field gets added to one and not the other; you ship a bug. `z.infer` reduces the "two artefacts kept in lockstep" problem to "one artefact, two read modes."

## Mechanics

### Basic derivation

```ts
const UserSchema = z.object({
  name: z.string(),
  age: z.number(),
  isCool: z.boolean(),
});

type User = z.infer<typeof UserSchema>;
//   ^? { name: string; age: number; isCool: boolean }
```

The type updates automatically when you add fields, change types, or apply modifiers (`.optional()`, `.default()`).

### Input vs output divergence — `z.input` vs `z.infer`

When the schema *transforms* values (`.default()`, `.transform()`), the input shape and output shape diverge. Zod exposes both:

```ts
const Form = z.object({
  repoName: z.string(),
  keywords: z.array(z.string()).default([]),
});

type FormInput  = z.input<typeof Form>;
//   ^? { repoName: string; keywords?: string[] | undefined }

type FormOutput = z.infer<typeof Form>;
//   ^? { repoName: string; keywords: string[] }
```

- `z.input<typeof S>` — what the parser *accepts* (pre-default, pre-transform).
- `z.infer<typeof S>` (also `z.output`) — what the parser *returns* (post-default, post-transform).

This is the bridge between a permissive external contract (form, API) and the strict internal model.

### Composing the pattern

```ts
const Id   = z.string().uuid();
const Base = z.object({ id: Id });

const User    = Base.extend({ name: z.string() });
const Post    = Base.extend({ title: z.string(), body: z.string() });
const Comment = Base.extend({ text: z.string() });

type User    = z.infer<typeof User>;
type Post    = z.infer<typeof Post>;
type Comment = z.infer<typeof Comment>;
```

The composition (`extend`, `merge`) carries through to the derived types.

## When to use

- Any boundary type that's also validated at runtime — API responses, form models, env configs, parsed files.
- Anywhere you'd otherwise hand-write a `type User = { ... }` next to a schema.

## When NOT to use

- Pure internal types with no runtime validation — `type Foo = { ... }` is fine and faster to read than a schema.
- Performance-critical hot paths where you want to avoid even constructing the schema value (rare).

## Common patterns

### Parse helper exposing both types

```ts
export type FormInput  = z.input<typeof Form>;
export type FormOutput = z.infer<typeof Form>;

export const validateForm = (input: FormInput): FormOutput =>
  Form.parse(input);
```

### Re-using the schema for the runtime check + the React form type

```ts
const SignupSchema = z.object({ email: z.email(), password: z.string().min(8) });
type SignupInput = z.input<typeof SignupSchema>;

function SignupForm() {
  const onSubmit = (values: SignupInput) => {
    const parsed = SignupSchema.parse(values);   // throws if bad
    // ...
  };
}
```

## Related

- [[zod]] — the library.
- [[runtime-type-validation]] — the broader category.
- [[ts-vs-js]], [[ts-compiler-tsc]] — TS type erasure makes this pattern necessary.

## Sources

- [[video-zod]]
