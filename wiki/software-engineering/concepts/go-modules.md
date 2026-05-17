---
title: Go Modules
pillar: software-engineering
type: concept
tags: [go, dependency-management, build-system]
status: in-progress
sources: ["[[learning-go-ch00-environment-setup]]"]
created: 2026-05-17
updated: 2026-05-17
---

# Go Modules

## Definition

A **Go module** is the unit of source distribution and dependency tracking in Go. It is a directory tree containing source code *plus* a `go.mod` file at its root that declares the module's name, its Go version requirement, and its exact dependencies. Initialized with `go mod init <module-name>`.

## Why it matters

Modules are how Go decided to do dependency management — and the choices Go made are unusual enough to be worth understanding even if you primarily work in other languages. Module versioning, minimum version selection, and the lack of a central package registry are deliberate trade-offs that contrast sharply with npm, PyPI, or Maven Central. For a staff engineer, knowing *why* Go chose this shape is more valuable than memorizing the commands.

## Mechanics

- **Create a module:** `go mod init <name>` — writes a `go.mod` file in the current directory.
- **`go.mod` minimal contents:**
  ```
  module hello_world   // name of the module
  go 1.20              // minimum Go version supported
  ```
- **Don't hand-edit `go.mod`.** Use `go get` to add a dependency and `go mod tidy` to prune unused entries and add missing ones.
- **Module name is significant** — `go build` produces a binary named after the module by default. Override with `go build -o <name>`.

## Comparison to other ecosystems

| Language | Manifest file |
|---|---|
| Go | `go.mod` |
| Python | `requirements.txt` (or `pyproject.toml`) |
| Ruby | `Gemfile` |
| Node.js | `package.json` |
| Rust | `Cargo.toml` |

A `go.mod` is closest in spirit to `Cargo.toml` — both declare module identity, version requirements, and dependencies in a single tool-managed file.

## Examples

Initializing a module called `hello_world`:

```bash
go mod init hello_world
```

Resulting `go.mod`:

```
module hello_world

go 1.20
```

## Related

- [[go-toolchain]] — `go build`, `go fmt`, `go vet` all operate on modules.
- [[makefiles]] — typical way to wrap module-level commands.

## Sources

- [[learning-go-ch00-environment-setup]] (`raw/books/Learning Go/00_Setting up your go environment.md`)
