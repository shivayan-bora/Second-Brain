---
creation date: 2026-04-20 22:42
modification date: Monday 20th April 2026 22:42:21
tags:
  - chapter
status:
  - in-progress
---

## If-Else

```go
if role == "admin" {
    // Admin access granted 
} else if role == "user" {
    // User access granted
} else {
    // Access denied
}
```

- Unlike languages like [[C]], [[JavaScript]] and [[Java]], in Go doesn't need to define it's condition inside brackets `()`.

## Switch-Case

```go
switch x {
	case 0:
		// Zero	
	case 1: 
		// One	
	case 2: 
		// Two	
	default: 
		// Other	
}
```

- Like [[Python]] and unlike some other languages like [[C]], [[Java]] and [[JavaScript]], Go doesn't need explicit `break` statements to prevent fallover.
