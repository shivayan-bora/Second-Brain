---
creation date: 2026-04-22 21:35
modification date: Wednesday 22nd April 2026 21:35:01
tags:
  - chapter
status:
  - in-progress
---
- This is a classification made on the type of data.
- They categorize a set of related values, describe the operations that can be done on them and how they're stored in the memory, also known as [[Memory Allocation]].
- Some of Go's most common variable [types](https://go.dev/ref/spec#Types) are:
	- `int`: a signed integer
	- `bool`: a boolean value, either `true` or `false`
	- `string`: a sequence of characters
	- `float64`: a floating-point number
	- `byte`: exactly what it sounds like: 8 bits of data
- [[Statically Typed Programming Languages]] are the ones where the type is determined at compile time and the [[Compiler]] throws an error when types are used incorrectly.
	- Types can't change after initialization
	- e.g. [[C++]], [[C]], [[Java]] etc.
	- **Advantages**
		- Better performance
		- Bugs caught early by the compiler
		- Better data integrity
- [[Dynamically Typed Programming Languages]] are the ones where the type is not enforced at compile time. These usually have incorrect operations or runtime errors in case of incorrect types.
	- Types can change after initialization
	- e.g. [[Python]], [[JavaScript]]
	- **Advantages**
		- Faster to write code
		- Less rigid generally
		- Lesser learning curve
- [[Go]] is a statically typed [[Compiled Programming Languages|compiled language]] with type inference which is sort of best of both worlds.

## Data Types

- **Integers**:
	- Unsigned:
		- `uint8`: 8 bits
		- `uint16`: 16 bits
		- `uint32`: 32 bits
		- `uint64`: 64 bits
	- Signed:
		- `int8`: 8 bits
		- `int16`: 16 bits
		- `int32`: 32 bits
		- `int64`: 64 bits
		- `int`: 32 bits on 32 bit machines and 64 bits on 64 bit machines
- **Floats or Floating Point Numbers**:
	- Contains decimals
		- `float32`: 32 bits
		- `float64`: 64 bits
- **String**:
	- Sequence of characters
	- `string`: 16 bytes
- **Booleans**:
	- `bool`: 1 byte
	- Contains two values `true` and `false`

## Variable

### Declaration

```go
// Explicit types
var <name> <type> = <value>

// Type inference
var <name> = <value>
<name> := <value> // Walrus Operator :=
```

#### Other Ways of Declaration

```go
// when data types are same
var s,t string = "foo", "bar"

// when data types are different
var (
	s string = "foo"
	i int = 64
)
```

### Printing with Format Specifiers

- `%v`: formats the value in the default format
- `%d`: formats decimal integers
- `%T`: type of the value
- `%c`: character
- `%q`: quoted characters/string
- `%s`: plain string
- `%t`: boolean
- `%f`: floating point numbers
	- `%.2f`: floating point numbers upto two decimal places

## Scope

- Scope is defined as the part of the program where a particular variable is accessible or from where it can referenced.
