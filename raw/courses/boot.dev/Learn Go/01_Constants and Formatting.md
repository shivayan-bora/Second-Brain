---
creation date: 2026-05-18 20:07
modification date: Monday 18th May 2026 20:07:55
tags:
  - chapter
status:
  - in-progress
aliases: []
id: 01_Constants and Formatting
---

## Constants

- Constants are immutable values that cannot be changed after they are defined. They are declared using the `const` keyword.
  - Constants can't use the `:=` short declaration syntax.

```go
const Pi = 3.14
```

- Constants must be known at compile time, however, we can also declare a constant with a computed value.

```go
const firstName = "Shivayan"
const lastName = "Bora"
const fullName = firstName + " " + lastName
```

- That being said, you can't declare a constant that can only be computed at runtime.

```go
// The current time is not a constant because it can only be computed at runtime
const currentTime = time.Now() // This will cause a compile-time error
```
