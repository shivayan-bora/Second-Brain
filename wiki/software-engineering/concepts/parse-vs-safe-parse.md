---
title: "Zod — `parse` vs `safeParse`"
pillar: software-engineering
type: concept
tags: [zod, validation, error-handling, typescript]
status: stable
sources: ["[[video-zod]]"]
created: 2026-06-09
updated: 2026-06-09
---

# Zod — `parse` vs `safeParse`

## Definition

Zod schemas expose two validation entry points: `parse(input)` **throws** a `ZodError` on validation failure; `safeParse(input)` **returns** `{ success: true, data } | { success: false, error }`. Same validation logic, different error-handling shape.

## Why it matters

The choice is about *what should happen at the call site when validation fails*. `parse` is right when failure is a programmer error or genuinely unrecoverable; `safeParse` is right when failure is a user-input or external-system reality you need to handle gracefully.

## Mechanics

### `parse` — throws

```ts
const Schema = z.object({ name: z.string() });

const data = Schema.parse(input);  // typed; throws ZodError on bad input
// 'data' is { name: string }
```

Use when:

- **Startup-time validation** (env vars, config files) — failure means "the program is broken; crash now."
- **Internal boundary** where the caller is your own code — throwing is fine because you control the producer.
- **Express middleware** that catches all errors and converts to HTTP responses — let the error propagate.

### `safeParse` — returns a discriminated union

```ts
const result = Schema.safeParse(input);

if (result.success) {
  use(result.data);    // typed; { name: string }
} else {
  showErrors(result.error);   // ZodError instance
}
```

Use when:

- **User input** — form submission, search query, anything from outside.
- **External APIs** — partner systems, third-party callbacks.
- **You want to branch** on success/failure without try/catch noise.
- **Multiple validators in sequence** where you want to report all failures, not crash on the first.

## A working rule

> Reach for `safeParse` by default at any boundary where the user (or another system) could legitimately send bad data. Reach for `parse` only when failure is "I should never see this in production."

## Examples

### Env validation at startup → `parse`

```ts
const EnvSchema = z.object({
  DATABASE_URL: z.string().url(),
  PORT: z.coerce.number().int().positive(),
});

export const env = EnvSchema.parse(process.env);   // crash fast
```

### Form submit → `safeParse`

```ts
const result = SignupSchema.safeParse(formValues);

if (!result.success) {
  setErrors(formatZodErrors(result.error));
  return;
}

await api.signup(result.data);
```

### API response → `safeParse` + branch on result

```ts
const parsed = ApiResponseSchema.safeParse(await response.json());

if (!parsed.success) {
  log.warn("api response shape changed", parsed.error);
  return fallbackData;
}

return parsed.data;
```

## Related

- [[zod]] — the library.
- [[runtime-type-validation]] — the broader category; both modes are common across validators.
- [[silent-failure]] _(future)_ — both modes can hide failures; `safeParse` is more error-prone here because it requires the caller to check `.success`.

## Sources

- [[video-zod]]
