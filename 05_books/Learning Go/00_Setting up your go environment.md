---
creation date: 2026-04-20 09:18
modification date: Monday 20th April 2026 09:18:44
tags:
  - chapter
status:
  - completed
---

## Making a Go Module

- Run `go mod init hello_world`
- A [[Go Modules|Go Module]] is created via this command.
	- For now a [[Go]] project is called a **module**.
		- It's not just source code but also an exact specification of the dependencies of the code within the module
	- Every module has a `go.mod` file in its root directory. Running `go mod init` creates this file for us.
		- This is similar to `requirements.txt` used by [[Python]] or the `Gemfile` used by [[Ruby]] or `package.json` by [[Node.js]].
		- You shouldn't edit the `go.mod` file directly. Instead use `go get` and `go mod tidy` to manage changes to the file.
	- The basic contents of `go.mod` file looks like this:

```go.mod
module hello_world // name of the module

go 1.20 // minimum supported version of Go for the module and any other modules that this module depends on
```

## Hello World Application

```go
// package declaration - a module can have code organized into one or more packages
package main // main package contains code that starts a go program

// import declaration - go imports the whole package - you can't specify specific types, functions, constants, or variables within a package
import "fmt"

// entry poihnt of the application
func main() {
	// prints `Hello, world!` to the console
	fmt.Println("Hello, world!")
}
```

### Go Tools

#### Go Build

- `go build` to create the binary executable called `hello_world` (or `hello_world.exe` for [[Windows]]) in the current directory.
	- Name of the binary matches the name in module declaration.
	- In case you want to name your binary differently, use the `-o` flag in the build command like: `go build -o hello` which creates a binary named `hello`.

#### Go Fmt

- `go fmt ./...` to format the code.

> [!TIP]
> Remember to run `go fmt` before you compile your code, and, at the very least, before you commit source code changes to your repository! If you forget, make a separate commit that does _only_ **`go fmt ./...`** so you don’t hide logic changes in an avalanche of formatting changes.

- By default, Go like [[Java]] and [[C]] uses semicolons (`;`) to terminate statements but unlike [[C]], these don't appear in the source code.
	- `go fmt` automatically inserts a `;` at the end of each statement in the source code as per rules defined in [Effective Go](https://go.dev/doc/effective_go#semicolons) and we should **never put a `;` by ourselves**.
	- The [[Lexer]] automatically inserts the `;` after the following token based on its rules:
		- An identifier (which includes words like `int` and `float64`)
		- A basic literal such as a number or string constant
		- One of the tokens: `break`, `continue`, `fallthrough`, `return`, `++`, `--`, `)`, or `}`

```go
func main()
{
	fmt.Println("Hello, world!")
}
```

- The above the becomes, which is not valid Go:

```go
func main();
{
	fmt.Println("Hello, world!");
};
```

#### Go Vet

- `go vet` detects code which is syntactically valid but quite likely incorrect. e.g.

```go
fmt.Printf("Hello, %s!\n")
```

- Here you have a template i.e. `Hello, %s!\n` with a `%s` placeholder, but no value is specified for the placeholder.
- Running `go vet` gives the following error:

```bash
$ go vet ./...
# hello_world
# ./hello.go:6:2: fmt.Printf format %s reads arg #1, but call has 0 args
```

- The following fixes it:

```go
fmt.Printf("Hello, %s!\n", "world")
```

#### Makefiles

- Makefiles allow developers to specify steps for repeatable, automatable builds that can be run anyone, anywhere and at any time.
- Go uses `make` for the same. It allows developers to specify a set of operations that are necessary to build a program and the order in which the steps must be performed.

```makefile
.DEFAULT_GOAL:=build

.PHONY:fmt vet build
fmt:
	go fmt ./...

vet: fmt
	go vet ./...
	
build: vet
	go build
```

- Each possible operation is called a **target** i.e. the word before `:` which are `fmt`, `vet` and `build`.
	- Tasks performed by the target are on the indented lines after the target.
	- After the target (`:`), any words available specifies the other targets to run before the specified target runs.
- `.DEFAULT_GOAL` defines which target is run when no target is specified i.e. `build`.
- `.PHONY` keeps `make` from getting confused if a directory or file in the project has the same name as one of the listed targets.
- We can invoke the `make` command to run this `Makefile`.
	- We can use `make vet` or `make fmt` to run specific commands.

```bash
$ make
go fmt ./...
go vet ./...
go build
```

> [!NOTE]
> You can't run `make` on [[Windows]] machines before installing `make` to your system.

> [!NOTE]
> The tasks specified in a target has to be indented with a tab for valid `make` syntax.
