---
creation date: 2026-04-17 21:00
modification date: Friday 17th April 2026 21:00:17
tags:
  - chapter
status:
  - completed
---

```go
package main

import "fmt"

func main() {
	Hello() // Hello, World!
	fmt.Println(Add(1, 2, 3, 4, 5)) // 15
	firstName, lastName := FullName()
	fmt.Println(firstName, lastName) // Alice Smith
}

// function declaration
func Hello() {
	fmt.Println("Hello, World!")
}

// function with a single return type
// arguments can be specified like this also
func Add(a, b, c, d, e int) int {
	return a + b + c + d + e
}

// function with multiple return values
func FullName() (string, string) {
	return "Alice", "Smith"
}

func MonthAndYear() (string, int) {
	month := "April"
	year := 2012
	return month, year
}
```

## Arguments

```go
package main

import "fmt"

func main() {
	Greetings("Shivayan") // Greetings, Shivayan
	CreateFullName("Shivayan", "Bora") // Shivayan Bora
}

// function with arguments
func Greet(name string) {
	fmt.Println("Greetings,", name)
}

// function with multiple arguments
func CreateFullName(firstName string, lastName string) {
	fmt.Println(firstName, lastName)
}
```

## Return Types

```go
package main

import "fmt"

func main() {
	fmt.Println(Add(1, 2, 3, 4, 5)) // 15
	firstName, lastName := FullName()
	fmt.Println(firstName, lastName) // Alice Smith
	var month, year = MonthAndYear()
	fmt.Println(month, year) // April 2012
}

// function with a single return type
// arguments can be specified like this also
func Add(a, b, c, d, e int) int {
	return a + b + c + d + e
}

// function with multiple return values
func FullName() (string, string) {
	return "Alice", "Smith"
}

func MonthAndYear() (string, int) {
	month := "April"
	year := 2012
	return month, year
}
```
