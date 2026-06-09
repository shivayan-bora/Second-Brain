---
creation date: 2026-06-01 21:08
modification date: Monday 1st June 2026 21:08:49
tags:
  - chapter
status:
  - in-progress
aliases: []
id: 01_Hello World
---

```go
package main

import "fmt"

func main() {
	fmt.Println("Hello, world")
}
```

- Packages are ways of grouping up related [[Go]] code together.
- With `import "fmt"`, we're importing a package which contains the `Println` function that we use to print to the console.

## How to test?

- It is good to separate your "domain" code from the outside world (side-effects). The `fmt.Println` is a side effect (printing to `stdout`), and the string we send in is our domain.

```go
package main

import "fmt"

// Returns a string
func Hello() string {
	return "Hello, world"
}

func main() {
	fmt.Println(Hello())
}
```

- Let's write tests:

```go
package main

import "testing"

func TestHello(t *testing.T) {
	got := Hello()
	want := "Hello, world"

	if got != want {
    // %q wraps text in double quotes
		t.Errorf("got %q want %q", got, want) // 👈 fails the test and prints a formatted text
	}
}
```

- To run tests: `go test`
- We already created a [[Go Modules|module]], but if that weren't there, we would get the following error:

```bash
$ go test
go: cannot find main module; see 'go help modules'
```

- To fix this, run the command from [[00_Install Go]] to initialize a Go module in your project.
- The `go.mod` that gets generated tells the `go` tools essential information about the code. e.g.
  - if you planned to distribute your application, you would include where the code was available for download as well as information about dependencies.
  - The name of the module, `shivayan-bora/learn-go-with-tests` usually refers to a URL from where the module could be found and downloaded from.

## Writing Tests

- [[Go Standard Library]] has a built-in testing framework for us to use.
- There are a few key rules when writing tests:
  - It needs to be in a file with a name like `xxx_test.go`
  - The test function should start with the word `Test`
  - The test function takes only one argument `t *testing.T`
  - To use the type `*testing.T`, you need to import `"testing"` in your file.
    - `t` of type `*testing.T` is a hook into the testing framework to be able to use it's functions like `t.Fail()` when you want your test to fail.

- Make the following modification to the test:

```go
package main

import "testing"

func TestHello(t *testing.T) {
	t.Run("saying hello to people", func(t *testing.T) { // 👈 Subtest: Used for grouping related tests together
		got := Hello("Shivayan")
		want := "Hello, Shivayan"

		if got != want {
			t.Errorf("got %q want %q", got, want)
		}
	})

	t.Run("say 'Hello, World' when an empty string is supplied", func(t *testing.T) { // 👈 Subtest: Used for grouping related tests together
    got := Hello("")
		want := "Hello, World"

		if got != want {
			t.Errorf("got %q want %q", got, want)
		}
	})
}
```

- This will now cause the tests to fail. Make the following changes in code to make the tests pass:

```go
package main

import "fmt"

const englishHelloPrefix = "Hello, " // 👈 A constant

func Hello(name string) string { // 👈 Accepts a `name` parameter as an argument which is of type `string`
	if name == "" {
		name = "World"
	}

	return englishHelloPrefix + name
}

func main() {
	fmt.Println(Hello("world"))
}
```

- Let's refactor the tests to make the test description more meaningful and remove duplicate code:

```go
package main

import "testing"

func TestHello(t *testing.T) {
	t.Run("saying hello to people", func(t *testing.T) {
		got := Hello("Shivayan")
		want := "Hello, Shivayan"

		assertCorrectMessage(t, got, want)
	})

	t.Run("empty string defaults to 'World'", func(t *testing.T) {
		got := Hello("")
		want := "Hello, World"

		assertCorrectMessage(t, got, want) // `testing.TB` allows you to call a helper function or a benchmark from a test
	})
}

// We can shorten parameters when we have more than one argument of the same type e.g. (got string, want string) to (got, want string)
func assertCorrectMessage(t testing.TB, got, want string) { // 👈 `testing.TB` is an interface that both `*testing.T` and `*testing.B` satisfy
	t.Helper() // 👈 Tells the test suite that this is a helper function. The line reported during error will be our function call rather than the helper

	if got != want {
		t.Errorf("got %q want %q", got, want)
	}
}
```

## Final state

```go
package main

import "fmt"

// Grouped constants
const (
	spanish            = "Spanish"
	french             = "French"
	englishHelloPrefix = "Hello, "
	spanishHelloPrefix = "Hola, "
	frenchHelloPrefix  = "Bonjour, "
)

func greetingPrefix(language string) (prefix string) { // 👈 Named return
	switch language {
	case spanish:
		prefix = spanishHelloPrefix // 👈 No break needed in Go
	case french:
		prefix = frenchHelloPrefix  // 👈 No break needed in Go
	default: // 👈 Default case in case nothing matches
		prefix = englishHelloPrefix // 👈 No break needed in Go
	}

	return // 👈 will return `prefix`
}

func Hello(name, language string) string {
	if name == "" {
		name = "World"
	}

	return greetingPrefix(language) + name
}

func main() {
	fmt.Println(Hello("world", ""))
}
```

- A few new concepts:
  - `(prefix string)` is a named return.
    - A variable with name `prefix` which is of type `string` gets created.
    - Even if we don't specify what to return, it will return `prefix`
- In Go, public functions start with an uppercase letter and private functions start with a lowercase letter.

```go
package main

import "testing"

func TestHello(t *testing.T) {
	t.Run("saying hello to people", func(t *testing.T) {
		got := Hello("Shivayan", "")
		want := "Hello, Shivayan"

		assertCorrectMessage(t, got, want)
	})

	t.Run("saying hello to people in Spanish", func(t *testing.T) {
		got := Hello("Shivayan", "Spanish")
		want := "Hola, Shivayan"

		assertCorrectMessage(t, got, want)
	})

	t.Run("saying hello to people in French", func(t *testing.T) {
		got := Hello("Debanjali", "French")
		want := "Bonjour, Debanjali"

		assertCorrectMessage(t, got, want)
	})

	t.Run("empty string defaults to 'World'", func(t *testing.T) {
		got := Hello("", "")
		want := "Hello, World"

		assertCorrectMessage(t, got, want)
	})
}

func assertCorrectMessage(t testing.TB, got, want string) {
	t.Helper()

	if got != want {
		t.Errorf("got %q want %q", got, want)
	}
}
```
