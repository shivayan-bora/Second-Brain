---
creation date: 2026-04-17 11:58
modification date: Friday 17th April 2026 11:58:39
tags:
  - course
status:
  - completed
---

```go
package main

import "fmt"

func main() {
	fact := "Go 1.0 was released in"
	year := 2012

	fmt.Println(fact, year)
}
```

## Types

- `int`, an integer number, e.g., `42`, `0`, or `-200`
- `bool`: `true` or `false`
- `float64`, a decimal, e.g., `3.1415`
- `string`, a text, e.g., `"Alice"`

## Variable Declaration

- Using walrus operator and type inference:
	- `fact := "Go 1.0 was released in`: Will automatically assign type to `fact` as a `string`
	- `year := 2012`: `year` as `int`
	- Can only be used inside a function scope i.e. as a **local variable** only.
- `var <name> <type>`: Assigns the zero value of `type` to the variable.
- `var firstName = "Shivayan"`: Type inference.

### Constants

- Replacing `var` with a `const` will declare a constant.

```go
package main

import "fmt"

func main() {
	const pi = 3.14
	fmt.Println("Value of Pi:", pi)
}
```

### Globals

- Declaring a variable inside a function: **Local Variable**
- Declaring a variable outside a function: **Global Variable**

```go
var globalName = "Shivayan"

func main() {
	localVariable := "Debanjali"
}
```

### Var Blocks

```go
var (
	name = "Alice"
	hours = 10
)
```

```go
const (
	pi = 3.1415
	hoursInDay = 24
)
```
