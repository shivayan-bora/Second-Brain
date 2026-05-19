---
creation date: 2026-05-18 17:28
modification date: Monday 18th May 2026 17:28:09
tags:
  - chapter
status:
  - completed
aliases: []
id: 00_Variables in Go
---

## Why Go?

- Fast and Lightweight
- Easily concurrent
- Easy and simple syntax
- [[Compiled Programming Languages|Compiled language]]
  - To run on machines, we need to compile our code into machine code. This is done by the Go compiler, which takes our Go source code and produces an executable binary that can be run on the target hardware i.e. in our case the CPU.
  - Go is faster than [[Interpreted Programming Languages|interpreted languages]] like [[Python]] and [[JavaScript]] because it is compiled directly to machine code, which can be executed directly by the CPU without the need for an interpreter or virtual machine.
  - Go is however slower than [[Rust]], [[Zig]] and [[C]] counterparts because it has additional features like garbage collection and a more complex runtime, which can introduce some overhead. However, Go's performance is still very good for most applications and is often sufficient for many use cases.
  - That being said, Go compiles faster than [[Rust]], [[Zig]] and [[C]] counterparts.

![[Pasted image 20260518193505.png]]

![[Pasted image 20260518195146.png]]

- [[Statically Typed Programming Languages|Statically typed]]
- [[Garbage Collection|Garbage collected]]
- Small memory footprint: Go programs are fairly lightweight. Each program includes a small amount of extra code that's included in the executable binary called the Go Runtime.
  - One of the purposes of the Go runtime is to clean up unused memory at runtime. It includes a garbage collector that automatically frees up memory that's no longer in use.

## Basic Hello World

```go
package main

import "fmt"

func main() {
  fmt.Println("Hello, World!")
}
```

- `package main`: Let's [[Go]] compiler know that we want this code to compile and run as a standalone program, as opposed to being a library that's imported by other programs.
- `import "fmt"`: This line imports the `fmt` package from the [[Go Standard Library]], which provides functions for formatted I/O, such as printing to the console. In this case, we will use it to print "Hello, World!" to the console.
- `func main()`: This is the entry point of a Go application. When we run the compiled binary, the `main` function will be executed first.

## Comments

```go
// This is a single-line comment

/* This is a multi-line comment
   that spans multiple lines
*/
```

## Variable Declaration

- `var` is used to declare a variable in Go.

```go
var myNum int
myNum = 42
```

- You can also declare and initialize a variable in one line:

```go
var myNum int = 42
```

- You can omit the type if it can be inferred from the value:

```go
var myNum = 42
```

- You can also use the short variable declaration syntax, also known as the walrus operator `:=` (only inside functions and can't be used globally):

```go
myNum := 42
```

- Same line declaration and initialization:

```go
myNum, myStr := 42, "Hello"
```

## Basic Data Types

- `int`: Signed integer.
- `float64`: Floating-point number.
- `bool`: Boolean value (`true` or `false`).
- `string`: Sequence of characters.
- `byte`: Alias for `uint8`, represents a byte or 8 bits of data.

### Type Sizes

- Signed Integers: `int`, `int8`, `int16`, `int32`, `int64`
- Unsigned Integers: `uint`, `uint8`, `uint16`, `uint32`, `uint64`, `uintptr`
- Floating-Point Numbers: `float32`, `float64`
- Complex Numbers: `complex64`, `complex128`
- Boolean: `bool`
- String: `string`
- Byte: `byte`
- The default `int` and `uint` types are platform dependent and can be either 32 or 64 bits, depending on the architecture of the machine. On a 32-bit system, `int` and `uint` are 32 bits, while on a 64-bit system, they are 64 bits. The other integer types (`int8`, `int16`, `int32`, `int64`, `uint8`, `uint16`, `uint32`, `uint64`) have fixed sizes regardless of the platform.
