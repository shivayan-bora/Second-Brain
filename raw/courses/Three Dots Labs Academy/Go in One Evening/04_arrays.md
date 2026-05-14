---
creation date: 2026-04-19 22:00
modification date: Sunday 19th April 2026 22:00:59
tags:
  - chapter
status:
  - in-progress
---
- [[Arrays]] in Go keep a set of variables of the same type.
- They have a fixed size defined within brackets. These use [[Static Arrays]].

```go
// array declaration
var contactMethods [3]string

// array instantiation
var contactMethods = [3]string{"email", "phone", "sms"} 

// array instantiation using walrus operator
contactMethods := [3]string{"email", "phone", "sms"}
```

- These arrays have a 0-based index system for referencing the elements.

```go
// retrieve an item
email := contactMethods[0]

// set an array 
contactMethods[2] = "text"
```

- To find the length of an array: `len(contactMethods)`
