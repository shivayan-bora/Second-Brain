---
creation date: 2026-04-22 10:13
modification date: Wednesday 22nd April 2026 10:13:31
tags:
  - course
status:
  - completed
---
- Go was created by engineers at [[Google]].
- Production code was mostly written in [[C++]] or [[Java]] where [[Concurrency]] and [[Multithreading]] is quite important and universal.
- However, the engineers at [[Google]] were frustrated with the undue complexity that came with those languages.
- [[Go]] was created to combine:
	- the ease of programming of an [[Interpreted Programming Languages|interpreted]], [[Dynamically Typed Programming Languages|dynamically typed]] language like [[Python]]
	- with the efficiency and safety of a [[Statically Typed Programming Languages|statically typed]] [[Compiled Programming Languages|compiled]] language like [[C++]]
	- modern with support for networked and multi-core computing.

## Hello World

```go
package main

import "fmt"

func main() {
	// This is a comment
	fmt.Println("Hello World")
}
```

- `package main`: Package declaration
	- Packages are [[Go]]'s way of organizing and reusing code
	- These are a collection of files living within the same directory
	- This always must be the first statement in a [[Go]] program
	- When you build reusable pieces of code, you will develop a package as a shared library
	- `package main` makes the code executable
	- Entry point package of our executable Go program
- `import "fmt"`: Importing dependencies from other libraries
- `func main()`: Function declaration
	- `main` along with `package main` is the entry point of executable programs
		- Needn't be invoked
