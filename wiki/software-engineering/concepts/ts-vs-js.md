---
title: TypeScript vs JavaScript
pillar: software-engineering
type: concept
tags: [typescript, javascript, language-design, tooling]
status: in-progress
sources: ["[[total-typescript-00-setup]]"]
created: 2026-05-17
updated: 2026-05-17
---

# TypeScript vs JavaScript

## Definition

**TypeScript** is a statically-typed *superset* of [[programming-languages|JavaScript]]: every valid JavaScript program is a valid TypeScript program, plus TypeScript adds a type system that exists only at authoring/compile time. TypeScript is not executed directly — it is compiled (transpiled) down to JavaScript and *that* output is what runs in browsers and Node.js. See [[ts-compiler-tsc]].

## Why it matters

The TypeScript / JavaScript split is one of the cleanest real-world examples of a **language built to fix the tooling story of another language** without forking the runtime. The lesson generalizes beyond JS:

- You can ship a more disciplined authoring experience on top of an existing runtime by adding a compile step.
- The benefit isn't (only) catching bugs — it's enabling IDE features that the underlying language couldn't support: autocomplete on object shapes, safe rename refactors, jump-to-definition across modules.
- The cost is a build step, a second mental model (types vs runtime values), and a place where the two can drift.

For a staff engineer making a "should we adopt TypeScript?" call, the framing matters: TypeScript's value is largely **developer-experience and refactor safety at scale**, not runtime behavior.

## Mechanics

### Why TypeScript exists

- JavaScript's tooling was historically weak: IDEs could not reliably offer autocomplete or type-checking because JS is dynamically typed and has no declared shapes.
- As JS codebases grew, **manual refactoring** became the norm — there was no compiler to tell you which call sites broke when you renamed a field.
- In 2010, Microsoft used **ScriptSharp** internally to write C# that compiled to JavaScript — a precursor pattern.
- Microsoft then designed TypeScript itself: a language with types that compiles to JavaScript.

### Superset semantics

- **Every `.js` file is valid `.ts`.** Adopting TypeScript can be incremental — rename a file, add types where useful.
- TypeScript adds: explicit type annotations, interfaces, generics, enums, `as` casts, structural typing.
- TypeScript removes nothing at runtime — types are **erased** during compilation. There is no runtime type information from TS itself.

### The two views

| | JavaScript | TypeScript |
|---|---|---|
| File extensions | `.js`, `.jsx` | `.ts`, `.tsx` |
| Type checking | None at author time | Static, via the LSP server + `tsc` |
| Autocomplete | Best-effort guesses by IDE | Driven by declared/inferred types |
| Reaches the browser? | Directly | Only after compilation by [[ts-compiler-tsc|tsc]] |
| Refactor safety | Manual | Compiler-assisted |

## Examples

Plain JavaScript — the IDE has no idea what `user` is:

```javascript
function greet(user) {
  return "hello " + user.nmae;   // typo; runtime undefined, no warning
}
```

TypeScript — the type makes the typo a compile-time error:

```typescript
interface User { name: string }

function greet(user: User) {
  return "hello " + user.nmae;
  //                     ~~~~ Property 'nmae' does not exist on type 'User'. Did you mean 'name'?
}
```

The runtime behavior of the compiled output is *identical* to the JS version — the difference is entirely at authoring time.

## Related

- [[ts-compiler-tsc]] — how the `.ts` → `.js` transformation actually runs.
- [[programming-languages]] — TS/JS is a clean case of the "transpiled" execution model.

## Sources

- [[total-typescript-00-setup]] (`raw/courses/Total TypeScript/00_Kickstart your TypeScript Setup.md`)
