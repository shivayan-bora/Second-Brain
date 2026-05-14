---
creation date: 2026-04-19 22:07
modification date: Sunday 19th April 2026 22:07:11
tags:
  - chapter
status:
  - in-progress
---
- Slices are [[Dynamic Arrays]] i.e. these are [[Arrays]] whose dimensions can expand or shrink.

```go
var contacts []string

// Using walrus operator
contacts := []string{}
```

- A declared slice is equal to `nil` i.e. nothing or no value.
	- The slice is not initialized yet.
	- Trying to access elements of a `nil` value will cause the application to crash.

```go
var contacts []string

// This will crash your application with message:
// panic: runtime error: index out of range [0] with length 0
contacts[0] = "Jenny"
```

- You can use the slice literal to initialize an empty slice:

```go
contacts := []string{}
```

- Or preallocate some memory for a slice using `make`.

```go
// A slice of five empty strings
contacts := make([]string, 5)
```

- Initializing a slice with a set of values:

```go
contacts := []string{
	"Alice",
	"John",
	"Emma",
}
```

- To find the length of a slice: `len(contacts)`
