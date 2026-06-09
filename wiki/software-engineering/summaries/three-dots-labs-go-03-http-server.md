---
title: "Three Dots Labs — Go in One Evening 03: HTTP Server"
pillar: software-engineering
type: summary
tags: [course, chapter, go, http, networking]
status: stable
former_source: "raw/courses/Three Dots Labs Academy/Go in One Evening/03_http_server.md"
source_status: deleted
course: "Three Dots Labs — Go in One Evening"
created: 2026-05-17
updated: 2026-06-09
---

# Three Dots Labs — Go in One Evening 03: HTTP Server

> [!NOTE] Raw source deleted
> The raw note this summary was ingested from has since been deleted from the vault during a cleanup. The wiki page below is retained as a record of the user's prior notes. See `former_source` in frontmatter for the original path.

Standing up a working HTTP server in a dozen lines using the standard library's `net/http`. Routes via `HandleFunc`, query params via `r.URL.Query()`, custom status codes via `w.WriteHeader`.

## TL;DR

- Go ships with a **production-grade HTTP library** in the standard library — no Express/Flask/Sinatra needed. See [[go-http-server]].
- `http.HandleFunc(path, fn)` registers a route handler.
- `http.ListenAndServe(":8080", nil)` starts the server; usually wrapped in `log.Fatal` to surface startup errors.
- Handlers have the signature `func(w http.ResponseWriter, r *http.Request)`.
- Status code is implicitly `200 OK` once you write to `w`. To send a non-2xx, call `w.WriteHeader(code)` **before** writing any body.
- `w.WriteHeader` does **not** terminate the handler — you must `return` explicitly to short-circuit.

## Key takeaways

- **"Batteries included" is a real selling point.** A production HTTP server with sane defaults in stdlib changes how Go projects are bootstrapped. See [[go-http-server]].
- **The handler signature is the contract.** `http.ResponseWriter` is the output stream + header buffer; `*http.Request` carries the parsed URL, headers, and body. Memorize this shape — every Go middleware, framework, and test fake builds on it.
- **Headers (including status) must be flushed before the body.** A `w.WriteHeader(http.StatusBadRequest)` after `fmt.Fprint(w, ...)` is a no-op. The course frames this as "do it before any content is written."
- **`WriteHeader` is *not* `return`.** This is an early footgun — a handler that writes a 400 and falls through still runs the rest of the body. Explicit `return` is required.

## Notable passages

> "By default the HTTP handler returns `200 OK` status when any content is written to `http.ResponseWriter`. We can write custom status codes using `w.WriteHeader` and we need to do it before writing any content, otherwise it won't have any effect."
> — *Go in One Evening*, ch. 03 (`raw/courses/Three Dots Labs Academy/Go in One Evening/03_http_server.md`)

> "`w.WriteHeader` doesn't interrupt the execution of the handler function and if we need to finish an HTTP request early, we need to explicitly use `return`."
> — *Go in One Evening*, ch. 03

## Open questions

- When do real Go projects reach for routers like `chi`, `gorilla/mux`, or `gin` over stdlib's `http.ServeMux`? Path parameters and method-based routing are the obvious gaps.
- How is graceful shutdown wired up (`http.Server.Shutdown`)? The course uses the simpler `ListenAndServe` form.
- The handler-per-request model: is it goroutine-per-request? What does that imply for shared state?

## Cross-references

- [[three-dots-labs-go-02-functions]] — handler signatures are just functions with a fixed shape.
- [[three-dots-labs-go-06-conditionals]] — handlers branch on input validity.
- Concepts introduced: [[go-http-server]].
