---
title: Go HTTP Server (net/http)
pillar: software-engineering
type: concept
tags: [go, http, networking, stdlib, web]
status: in-progress
sources: ["[[three-dots-labs-go-03-http-server]]"]
created: 2026-05-17
updated: 2026-05-17
---

# Go HTTP Server (`net/http`)

## Definition

Go's standard library ships with `net/http`, a production-grade HTTP client and server. A working HTTP server in Go is a handful of stdlib calls — no third-party framework required. The package provides the route registration (`HandleFunc`), the server loop (`ListenAndServe`), and the handler signature `func(w http.ResponseWriter, r *http.Request)` that every Go web library builds on.

## Why it matters

"Batteries included" is often a marketing claim; in Go's case it's literal. `net/http` is sufficient for many production services, and even when teams reach for a router like `chi` or a framework like `gin`, they sit *on top of* the same handler signature. Learning `net/http` first means everything else fits into a frame you already understand — and it explains why the Go community is comparatively unenthusiastic about heavy web frameworks.

## Mechanics

### Minimal server

```go
package main

import (
    "fmt"
    "log"
    "net/http"
)

func main() {
    http.HandleFunc("/api/v1/user", handlerFunction)
    log.Fatal(http.ListenAndServe(":8080", nil))
}

func handlerFunction(w http.ResponseWriter, r *http.Request) {
    name := r.URL.Query().Get("name")
    fmt.Fprint(w, "Hello, my name is ", name)
}
```

### Handler signature

Every HTTP handler matches:

```go
func(w http.ResponseWriter, r *http.Request)
```

- `w http.ResponseWriter` — the response stream + header buffer. Write headers via `w.Header()` and `w.WriteHeader(code)`; write body via `fmt.Fprint`, `w.Write`, JSON encoders, etc.
- `r *http.Request` — the parsed request. Query params via `r.URL.Query().Get("...")`, headers via `r.Header`, body via `r.Body`.

### Status codes

- **Default:** writing any content to `w` causes a `200 OK` response.
- **Custom:** call `w.WriteHeader(http.StatusBadRequest)` (or another status) **before** writing the body. Headers — including the status line — are flushed on the first body write; writing them after has no effect.
- **`WriteHeader` does not return early.** It only sets the header. To stop processing the handler you must explicitly `return`:
  ```go
  if name == "" {
      w.WriteHeader(http.StatusBadRequest)
      return // required — otherwise the handler keeps running
  }
  ```

### Routing

- `http.HandleFunc(path, fn)` registers a function as the handler for `path` on the default `ServeMux`.
- Passing `nil` as the second argument to `ListenAndServe` uses the default mux.
- The default mux does **exact-match** routing on path. Path parameters and method-based routing (e.g. `GET /users/:id`) need a third-party router or Go 1.22+'s enhanced `ServeMux` pattern syntax.

## Examples

Reject blank query param with 400:

```go
func controllerFunc(w http.ResponseWriter, r *http.Request) {
    name := r.URL.Query().Get("name")
    if name == "" {
        w.WriteHeader(http.StatusBadRequest)
        return
    }
    fmt.Fprint(w, "Hello, ", name)
}
```

## Related

- [[go-functions]] — handlers are just functions with a fixed signature.
- [[go-conditionals]] — input validation in handlers is `if`-driven.
- [[go-packages]] — `net/http` is a standard-library sub-package imported via its full path.

## Sources

- [[three-dots-labs-go-03-http-server]] (`raw/courses/Three Dots Labs Academy/Go in One Evening/03_http_server.md`)
