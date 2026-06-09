---
id: JavaScript ES6 Modules vs CommonJS
aliases: []
tags:
  - article
creation date: 2026-06-08 11:26
modification date: Monday 8th June 2026 11:26:55
source: https://www.perplexity.ai/search/373f12d8-b970-42d4-b8d5-8d328ae5f873
status:
  - in-progress
---

## What is a JavaScript Module?

- A [[JavaScript ES6 Modules|JavaScript Module]] is just a file with its own scope that can expose some of it's values explicitly via exports.
- Anything not exported stays private to that file and can't be accessed directly by other files.
- e.g. each component file in a design system is a module and consumers only see what you export:

```tsx
// src/button/Button.tsx
type ButtonVariant = "primary" | "secondary";

interface ButtonProps {
  variant?: ButtonVariant;
  children: React.ReactNode;
}

export function Button({ variant = "primary", children }: ButtonProps) {
  const className = variant === "primary" ? "btn-primary" : "btn-secondary";
  return <button className={className}>{children}</button>;
}

// not exported – internal helper
function logButtonRendered() {
  // analytics integration, etc.
}
```

- In this example:
  - `Button` is exported.
  - `logButtonRendered` is private to this module.

## export and import Basics

- Modules communicate via `export` and `import`
  - `export`: What the [[JavaScript]] module exposes to the world.
  - `import`: What it depends on.

```ts
// src/button/index.ts
export { Button } from "./Button";
```

```tsx
// src/App.tsx
import { Button } from "@acme/ui/button";

export function App() {
  return <Button variant="secondary">Click me</Button>;
}
```

- Imports are static and hoisted – the module graph is known at build time, which enables [[Tree-Shaking|tree-shaking]].
- The imported bindings are read-only, though the underlying objects can be mutated.

## Named vs Default Exports

- Named exports: Multiple per file, imported by name.
- Default export: A single main export per file.

### Named Exports

```tsx
// src/button/Button.tsx
export function Button(...) { ... }
export function IconButton(...) { ... }
export type ButtonProps = {...};
```

````ts
// src/button/index.ts
export { Button, IconButton } from './Button';
export type { ButtonProps } from './Button';```
````

- Usage

```ts
import { Button, IconButton } from "@acme/ui/button";
```

### Default Exports

```tsx
// src/button/Button.tsx
function Button(...) { ... }
export default Button;
```

- Usage:

```tsx
import Button from "@acme/ui/button";
```

- For a design system:
- Prefer named exports for most components:
  - Better auto-complete / refactors.
  - Plays nicer with tree-shaking and dead-code elimination.
  - Easier to re-export from barrel files without renaming.
- Use default exports sparingly (if at all) – e.g., single configuration object or legacy compatibility.
- Example mixing both (possible, but often avoided):

```ts
// src/theme/index.ts
export const lightTheme = { ... };
export const darkTheme = { ... };

const defaultTheme = lightTheme;
export default defaultTheme;
```

## Barrel Files and Module Structure

- A barrel is a module that re-exports things from other modules to give consumers a clean API.
- Consider the following folder structure:

```
src/
  button/
    Button.tsx
    IconButton.tsx
    index.ts
  input/
    TextField.tsx
    PasswordField.tsx
    index.ts
  theme/
    tokens.ts
    index.ts
  index.ts
```

- Component barrel:

```ts
// src/button/index.ts
export { Button } from "./Button";
export { IconButton } from "./IconButton";
export type { ButtonProps } from "./Button";
```

- Root Barrel:

```ts
// src/index.ts
export * from "./button";
export * from "./input";
export * from "./theme";
```

- Consumers:

```tsx
import { Button, TextField, lightTheme } from "@acme/ui";
```

- This gives:
  - A single entry point for most consumers.
  - The ability to still import deep paths if needed: `@acme/ui/button`.
  - A clear separation between internal module graph and public API.
- In a real package, you'd pair this with `"exports"` in `package.json` to control what paths are public.

## Module Scope, Live Bindings and Tree-Shaking

### Nodule Scope

- Each module has its own scope and is in strict mode by default:
  - No accidental globals.
  - Internal variables aren't visible unless exported.

```ts
// src/theme/tokens.ts
const baseSpacing = 8; // private

export const spacing = {
  // public
  xs: baseSpacing,
  sm: baseSpacing * 2,
  md: baseSpacing * 3,
};
```

### Live Bindings

- ES6 Module imports are live views of the exported values and not copies.

```ts
// src/theme/currentTheme.ts
export let currentTheme = "light";

export function setTheme(name: "light" | "dark") {
  currentTheme = name;
}
```

```ts
// src/App.tsx
import { currentTheme, setTheme } from "@acme/ui/theme";

console.log(currentTheme); // 'light'
setTheme("dark");
console.log(currentTheme); // now 'dark'
```

- The import reflects the latest value, which is handy for global theme state (though in [[React]] you’d typically wrap this in context).

### Tree-Shaking

- Since imports/exports are static, bundlers can remove unused exports.

```ts
// src/input/index.ts
export { TextField } from "./TextField";
export { PasswordField } from "./PasswordField";
```

- If your app only imports `TextField`, `PasswordField` can be tree-shaken out of the bundle (assuming no side-effects).
- For a design system, this means:
  - Avoid side-effectful top-level code in modules e.g. automatic [[Document Object Model (DOM)|DOM]] mutations.
  - Mark `"side-effects": false` in `package.json` or selectively for files that are safe.

## Dynamic Imports for Heavy Components

- Dynamic imports let you load a module at runtime with import(), which returns a [[JavaScript Promises|Promise]].
- This is perfect for DS components that are:
  - Rarely used (e.g., `DatePicker`, `RichTextEditor`).
  - Heavy (large dependency trees).
- e.g. lazily loading a heavy component:

```ts
// consumer app
const DatePicker = React.lazy(() =>
  import("@acme/ui/date-picker").then((mod) => ({ default: mod.DatePicker })),
);
```

```ts
// src/date-picker/index.ts
export { DatePicker } from "./DatePicker";
```

- Dynamic imports are still ES modules; they just load asynchronously.

## CommonJS vs ES6 Modules

- [[CommonJS]] is the old [[node.js]] way and ES6 Modules are the standardized, browser-native and future-proof module systems.

### Syntax and Basic Usage

#### CommonJS (CJS)

```js
// math.cjs or math.js (CommonJS)
const PI = 3.14;

function area(radius) {
  return PI * radius * radius;
}

module.exports = {
  PI,
  area,
};
```

```js
// consumer.cjs
const { PI, area } = require("./math");

console.log(PI);
console.log(area(2));
```

#### ES6 Modules (ESM / ES6 Modules)

```js
// math.mjs or math.js (with "type": "module" in package.json)
export const PI = 3.14;

export function area(radius) {
  return PI * radius * radius;
}
```

```js
// consumer.mjs
import { PI, area } from "./math.js";

console.log(PI);
console.log(area(2));
```

### How they load and execute?

- CommonJS:
  - Modules load synchronously: require executes and returns the exported object immediately.
  - Module graph is built at runtime; you can call require conditionally or inside functions.

```js
if (process.env.NODE_ENV === "development") {
  const { installDevTools } = require("./dev-tools");
  installDevTools();
}
```

- ES Modules:
  - Modules are statically analyzed: imports/exports must be at the top level.
  - Loading is asynchronous conceptually, though bundlers hide that for you. Dynamic loading uses `import()`.

```js
// top-level, static
import { Button } from "@acme/ui";

// dynamic (code-splitting)
const DatePicker = await import("@acme/ui/date-picker");
```

### Where each is used?

- CommonJS
  - Historically the default in Node.js (`require`, `module.exports`).
  - Still very common in older libraries, build tooling, and many npm packages.
  - Not natively supported in browsers; must be bundled/transpiled.
- ES Modules
  - Standardized in ES2015 and supported natively in modern browsers.
  - Supported in Node via:
    - `"type": "module"` in `package.json`, or
    - `.mjs` extension.
  - Recommended for new Node and browser projects.

### Tooling, tree-shaking, and interop

- Tree-shaking and static analysis
  - CommonJS is harder to analyze because require is just a function; what’s required can depend on runtime logic.
  - ESM has static imports, so bundlers can see the entire dependency graph at build time and safely remove unused exports (tree-shaking).
- Node and bundlers support interop, with some rules:
  - ESM importing CJS: `module.exports` appears as the default export.
  - CJS requiring ESM: more awkward; often you need dynamic `import()` or a transpiled dual build.

```js
// ESM importing CJS
// math.cjs
module.exports = { PI: 3.14 };

// consumer.mjs
import math from "./math.cjs";

console.log(math.PI);
```
