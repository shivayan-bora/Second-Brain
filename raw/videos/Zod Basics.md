---
id: Zod
aliases: []
tags:
  - video
creation date: 2026-05-28 17:43
modification date: Thursday 28th May 2026 17:43:17
source: https://www.youtube.com/watch?v=ZPa9I_pvRU0
status:
  - in-progress
---

## Other References

- [Zod Documentation](https://zod.dev/)
- [Total TypeScript: Zod](https://www.totaltypescript.com/tutorials/zod)

## What is Zod?

- [[Zod]] is a library to provide runtime type-safety using [[TypeScript]] to your web application e.g. API responses, form inputs and external data.

## Getting Started

- Create a new empty folder known as `zod-basics`.
- Initialize [[pnpm]]: `pnpm init`
- Install TypeScript: `pnpm install --save-dev typescript`
- Create a file named: `main.ts`
- Add a `dev` script in `package.json`: `node --watch ./main.ts`
- To install zod: `pnpm install zod`

## Basics

- Zod works on something called a **schema**. Any data being received, it's shape is compared with this schema as validation.

### Primitives

- Zod provides basic primitives as functions for validation e.g. `z.string()`, `z.number()`, `z.boolean()` etc.
- The runtime validation comes into play through the `parse` method of the [[Zod Schema]].

```ts
import z from "zod";

const MySchema = z.boolean();

const value = true;

console.log(MySchema.parse(value));
```

- This will throw an error if the shape doesn't match the schema.

#### Safe Parse

- In case you don't want to throw an error and effectively brick your app, you can safely parse as follows:

```ts
import z from "zod";

const MySchema = z.boolean();

const value = true;

console.log(MySchema.safeParse(value));
```

- This won't throw an error but returns an object containing `success: true` for successful parsing or `success: false` for failed schema validations.

### Chaining

- [[Zod]] works on the principle of chaining where we can chain validations using the `.` operator.
- e.g. if we want to make a field optional:

```ts
const UserSchema = z.object({
  name: z.string(),
  age: z.number().optional(),
  isCool: z.boolean(),
});
```

- e.g. if we want to have a field that's optional but if not passed, then set a default value:

```ts
const UserSchema = z.object({
  name: z.string(),
  age: z.number().default(18),
  isCool: z.boolean(),
});
```

- If the minimum age should be `18`:

```ts
const UserSchema = z.object({
  name: z.string(),
  age: z.number()min(18),
  isCool: z.boolean(),
});
```

### Objects

- We can create an object schema as `z.object()`.
- We can also nest object schemas as shown below:

```ts
import z from "zod";

const UserSchema = z.object({
  name: z.string(),
  age: z.number(),
  isCool: z.boolean(),
  coordinates: z.object({
    lat: z.number(),
    lon: z.number(),
  }),
});

const myUser = {
  age: 35,
  name: "Shivayan Bora",
  isCool: true,
  coordinates: {
    lat: 50,
    lon: 60,
  },
};

console.log(UserSchema.parse(myUser));
```

- Zod ignores keys which aren't present in its schema. So if in the above example, we're getting a User object from an API with some extra fields, `UserSchema.parse` will strip out the extra fields and only pass the keys present in it's schema definition.

#### Partial and Required

- If we want to make all fields of an object as optional, we can use the `.partial()` function.
  - However if we are passing a value, it should be of the correct type regardless of `.partial()` i.e. either send the correct type or don't send at all.

```ts
const UserSchema = z.object({
  name: z.string(),
  age: z.number(),
  isCool: z.boolean(),
  coordinates: z
    .object({
      lat: z.number(),
      lon: z.number(),
    })
    .partial(),
});
```

- If you want to do the opposite and want to make sure each and every field is required, use the `.required()` function.

```ts
const UserSchema = z.object({
  name: z.string(),
  age: z.number(),
  isCool: z.boolean(),
  coordinates: z
    .object({
      lat: z.number(),
      lon: z.number(),
    })
    .required(),
});
```

#### Strict Objects

- If you want your object shape to match exactly like your schema, you can use the `.strict()`.
- If there's any extra field in the object to be validated against the schema.

```ts
import z from "zod";

const UserSchema = z
  .object({
    name: z.string(),
    age: z.number(),
    isCool: z.boolean(),
    coordinates: z.object({
      lat: z.number(),
      lon: z.number(),
    }),
  })
  .strict();

const myUser = {
  age: 35,
  name: "Shivayan Bora",
  isCool: true,
  auraPoints: 1000, // 👈 ❌ Error since this isn't a part of the UserSchema
  coordinates: {
    lat: 50,
    lon: 60,
  },
};

console.log(UserSchema.parse(myUser));
```

### Arrays

```ts
const UserSchema = z.object({
  name: z.string(),
  age: z.number(),
  isCool: z.boolean(),
  coordinates: z.object({
    lat: z.number(),
    lon: z.number(),
  }),
  friends: z.array(z.string()), // 👈 Array of strings
});
```

## Zod Utilities

- If we want a specific value to be between a specific range:

```ts
const UserSchema = z.object({
  name: z.string(),
  age: z.number().min(18).max(55).default(18), // 👈 Age should be between 18 and 55. If age isn't passed, it will default to 18
  isCool: z.boolean(),
  coordinates: z.object({
    lat: z.number(),
    lon: z.number(),
  }),
  friends: z.array(z.string()),
});
```

- Zod has many utilities for each type and check the documentation for the same.

## Deriving Types

- The schemas you define in [[Zod]] can actually evaluate down to a type.
- If you want to derive types from a [[Zod Schema]]:

```ts
import z from "zod";

const UserSchema = z.object({
  name: z.string(),
  age: z.number(),
  isCool: z.boolean(),
  coordinates: z.object({
    lat: z.number(),
    lon: z.number(),
  }),
});

const myUser = {
  age: 35,
  name: "Shivayan Bora",
  isCool: true,
  coordinates: {
    lat: 50,
    lon: 60,
  },
};

type User = z.infer<typeof UserSchema>; // 👈 Type inference from zod schema

const doSomething = (user: User) => {
  console.log(user);
};

doSomething(myUser);
```

- It's an extremely common pattern to define all your types in the form of Zod schema which will act as the source of truth. You can then derive all the necessary types using `z.infer<T>` and use them in the code for type safety.

## Advanced Tools

- This isn't going to be an exhaustive list.
- If you want a value to be number or string:

```ts
const UserSchema = z.object({
  name: z.string(),
  age: z.number().or(z.string()), // 👈 Age can be a number or string
  isCool: z.boolean(),
  coordinates: z.object({
    lat: z.number(),
    lon: z.number(),
  }),
});
```

- For narrowing types e.g. show can be a string with only two values: `open` or `close`

```ts
const UserSchema = z.object({
  name: z.string(),
  age: z.number(),
  isCool: z.boolean(),
  show: z.literal(['open', 'close']) // 👈 Show can only be `open` or `close`
  coordinates: z.object({
    lat: z.number(),
    lon: z.number(),
  }),
});

const FormUnion = z.object({
  repoName: z.string(),
  privacyLevel: z.union([z.literal("private"), z.literal("public")]),
});

const FormEnum = z.object({
  repoName: z.string(),
  privacyLevel: z.enum(["private", "public"]),
});
```

- If you want a variable to only have one value:

```ts
const UserSchema = z.object({
  name: z.string(),
  age: z.number(),
  isCool: z.boolean(),
  minAge: z.literal(18), // 👈 minAge can only be 18
  coordinates: z.object({
    lat: z.number(),
    lon: z.number(),
  }),
});
```

- Some other validations:
  - `z.email()`: Email validation
  - `z.url()`: URL validation
  - `z.uuid()`: UUID validation
  - `z.date()`: Date validation
  - `z.record(z.string(), z.number())`: To validate a record type
  - `z.null()`, `z.undefined()`, `z.nullable()`, `z.nullish()`, `z.any()`, `z.unknown()`, `z.never()`: Validates the same typescript types as mentioned

### Form Input and Output

- Imagine we have a form and we're validating form inputs.
- Imagine we have a form input known as `keywords`.
  - If we don't receive `keywords` in the form input, then we default it to a blank array.
- This effectively means, our form inputs and outputs are different and if we have to generate types, both the types should be different too.
  - Key difference being in our inputs, `keywords` can be a `string[]` or `undefined` while for outputs, it will be a `string[]`
- So we can create the `FormInput` type using `z.input` while the `FormOutput` type can be created by `z.infer` as shown below:

```ts
import { expect, it } from "vitest";
import { z } from "zod";

const Form = z.object({
  repoName: z.string(),
  keywords: z.array(z.string()).default([]),
});

type FormInput = z.input<typeof Form>; // 👈 Form Input Type
type FormOutput = z.infer<typeof Form>; // 👈 Form Output Type

export const validateFormInput = (values: FormInput): FormOutput => {
  const parsedData = Form.parse(values);

  return parsedData;
};
```

- This would mean, the shape of `FormInput` and `FormOutput` are as follows:

```ts
type FormInput = {
  repoName: string;
  keywords?: string[] | undefined;
};

type FormOutput = {
  repoName: string;
  keywords: string[];
};
```

### Composing Schemas

- Consider the following schema with some duplicated types:

```ts
const User = z.object({
  id: z.string().uuid(),
  name: z.string(),
});

const Post = z.object({
  id: z.string().uuid(),
  title: z.string(),
  body: z.string(),
});

const Comment = z.object({
  id: z.string().uuid(),
  text: z.string(),
});
```

- There are two ways to do it.

#### Creating id as it's own type

```ts
const Id = z.string().uuid();

const User = z.object({
  id: Id,
  name: z.string(),
});

const Post = z.object({
  id: Id,
  title: z.string(),
  body: z.string(),
});

const Comment = z.object({
  id: Id,
  text: z.string(),
});
```

#### Using extend method

```ts
const ObjectWithId = z.object({
  id: z.string().uuid(),
});

const User = ObjectWithId.extend({
  name: z.string(),
});

const Post = ObjectWithId.extend({
  title: z.string(),
  body: z.string(),
});

const Comment = ObjectWithId.extend({
  text: z.string(),
});
```

#### Using Merge

```ts
const User = ObjectWithId.merge(
  z.object({
    name: z.string(),
  }),
);
```

- Merging is generally used when two different types are being combined, rather than just extending a single type.

### Transform data within Schema

- There are two ways:

#### Transforming at the root schema level

```ts
const StarWarsPerson = z
  .object({
    name: z.string(),
  })
  .transform((person) => ({
    ...person,
    nameAsArray: person.name.split(" "),
  }));
```

- Inside of the `.transform()`, `person` is the object from above that includes the `name`.

#### Transforming at the field level

```ts
const StarWarsPerson = z.object({
  name: z.string().transform((name) => `Awesome ${name}`),
});
```
