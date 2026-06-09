---
title: Go Packages
pillar: software-engineering
type: concept
tags: [go, packages, imports, namespacing]
status: stable
sources: ["[[three-dots-labs-go-00-hello]]", "[[tour-of-go-00-packages]]", "[[learn-go-with-tests-01-hello-world]]"]
created: 2026-05-17
updated: 2026-06-09
---

# Go Packages

## Definition

A **package** is Go's unit of compilation and namespacing. Every Go source file begins with a `package <name>` declaration. Code in the same package shares an internal namespace; code in different packages communicates via **exported** (capitalized) identifiers. The special package `main` — with a `func main()` — is the entry point of an executable program.

## Why it matters

Packages, not files, are how Go organizes code. Understanding the package model is a prerequisite for everything else: visibility rules, import paths, circular-import avoidance, and how [[go-modules|modules]] aggregate packages for distribution. For a staff engineer, the package boundary is also the most important design unit in a Go codebase — it's where API decisions live.

## Mechanics

- **Every file declares its package.** `package main` for executables; some other name (matching the directory, by convention) for libraries.
- **Imports use string paths.** `import "fmt"` or `import "math/rand"`. Sub-packages are slash-separated. Third-party imports use their full repository path: `import "github.com/foo/bar"`.
- **Grouped imports.** Multiple imports go in parens:
  ```go
  import (
      "fmt"
      "math/rand"
      "net/http"
  )
  ```
- **`main` is special.** An executable program must have a `package main` containing `func main()`. A package with any other name compiles to a library.
- **Visibility is by capitalization.** `Println` is exported (callable from other packages); `println` is unexported (package-private). This applies to functions, types, methods, struct fields, and constants alike.
- **`math/rand` ≠ `math`.** The slash denotes a sub-package, not a sub-namespace within an existing import.

## Examples

Minimal executable:

```go
package main

import "fmt"

func main() {
    fmt.Println("Hello, World!")
}
```

Multiple imports, including a sub-package:

```go
package main

import (
    "fmt"
    "math/rand"
)

func main() {
    fmt.Println("My favorite number is", rand.Intn(10))
}
```

## Related

- [[go-modules]] — a module is a tree of packages distributed as a unit; `go.mod` lives at the root of a module, not a package.
- [[go-toolchain]] — `go build`, `go vet`, `go fmt` all operate at the package level by default (`./...` to recurse).
- [[go-functions]] — function visibility rules (capitalized = exported) apply at the package boundary.

## Sources

- [[three-dots-labs-go-00-hello]] (`raw/courses/Three Dots Labs Academy/Go in One Evening/00_hello.md`)
- [[tour-of-go-00-packages]] (`raw/documentation/Tour of Go/00_Packages.md`)
- [[learn-go-with-tests-01-hello-world]] — capitalization rule reinforced: `Hello` (exported, testable) vs `assertCorrectMessage` and `greetingPrefix` (unexported helpers).
