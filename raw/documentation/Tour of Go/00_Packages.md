---
creation date: 2026-05-15 10:01
modification date: Friday 15th May 2026 10:01:00
tags:
  - chapter
source:
status:
  - in-progress
aliases: []
id: 00_Packages
---

# Packages

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

- All [[Go]] programs are made of packages.
- This program is the part of the `main` package which is the entry point of a Go application.
