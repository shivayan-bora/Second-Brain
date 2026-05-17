---
title: Go Arrays
pillar: software-engineering
type: concept
tags: [go, arrays, collections, fixed-size]
status: in-progress
sources: ["[[three-dots-labs-go-04-arrays]]"]
created: 2026-05-17
updated: 2026-05-17
---

# Go Arrays

## Definition

A Go **array** is a **fixed-length** sequence of elements of a single type. The length is **part of the type**: `[3]string` and `[4]string` are different, incompatible types. Arrays are zero-indexed and zero-valued on declaration.

## Why it matters

In day-to-day Go you'll rarely use arrays directly — [[go-slices|slices]] are the workhorse. But arrays still appear in three places that matter: **as the backing store for slices** (which is why slice semantics are sometimes surprising), **as fixed-size buffers** (e.g. `[32]byte` for a SHA-256 hash, `[16]byte` for a UUID), and **as value types** with predictable memory layout. Understanding arrays first makes slices easier to reason about.

## Mechanics

### Declaration and instantiation

```go
// Declaration — zero-valued [3]string: ["", "", ""]
var contactMethods [3]string

// Declaration with literal
var contactMethods = [3]string{"email", "phone", "sms"}

// Short form (function scope)
contactMethods := [3]string{"email", "phone", "sms"}
```

### Access and assignment

Zero-indexed. Out-of-bounds access panics.

```go
email := contactMethods[0]   // read
contactMethods[2] = "text"   // write
```

### Length

```go
len(contactMethods) // 3
```

### Size is part of the type

```go
func acceptsThree(a [3]string) {}

var four [4]string
acceptsThree(four) // compile error: cannot use four (type [4]string) as type [3]string
```

This is the single most important property of Go arrays — and the reason slices exist.

## Examples

```go
package main

import "fmt"

func main() {
    contactMethods := [3]string{"email", "phone", "sms"}
    contactMethods[2] = "text"

    fmt.Println(contactMethods)         // [email phone text]
    fmt.Println(len(contactMethods))    // 3
}
```

## Related

- [[go-slices]] — the dynamic-length cousin, built on top of an underlying array. Almost always the right choice instead of a raw array.
- [[go-variables]] — array elements zero-value the same way primitive variables do.

## Sources

- [[three-dots-labs-go-04-arrays]] (`raw/courses/Three Dots Labs Academy/Go in One Evening/04_arrays.md`)
