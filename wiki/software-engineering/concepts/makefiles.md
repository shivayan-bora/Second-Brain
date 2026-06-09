---
title: Makefiles
pillar: software-engineering
type: concept
tags: [build-system, tooling, make]
status: stable
sources: ["[[learning-go-ch00-environment-setup]]"]
created: 2026-05-17
updated: 2026-06-09
---

# Makefiles

## Definition

A **Makefile** is a declarative build script processed by the `make` tool. It defines named **targets**, each with a list of **prerequisites** (other targets that must run first) and a list of **commands** to execute. `make` evaluates the dependency graph and runs only the work needed to satisfy the requested target.

## Why it matters

Make has been the lingua franca of build automation since 1976 and is still the path of least resistance for "give every project a single `make` entry point." For a staff engineer, the value isn't writing complex Makefiles — it's that **a working Makefile is the most universally portable contract for `clone → build → test`** across languages, CI systems, and contributor experience levels. Even when the underlying tool is Go, npm, or cargo, wrapping it in `make` gives new contributors a predictable verb to type.

## Mechanics

### Syntax basics

```makefile
.DEFAULT_GOAL := build

.PHONY: fmt vet build

fmt:
	go fmt ./...

vet: fmt
	go vet ./...

build: vet
	go build
```

- **Target** — the word before `:`. Here: `fmt`, `vet`, `build`.
- **Prerequisites** — words after `:`. `build: vet` means "run `vet` first." Make then sees `vet: fmt` and runs `fmt` first.
- **Commands** — indented lines under the target. **Must be indented with a literal tab**, not spaces.
- **`.DEFAULT_GOAL`** — which target runs if you type `make` with no argument.
- **`.PHONY`** — declares that these targets are not actual files. Without this, if a file named `build` existed in the directory, `make build` would think "nothing to do, the file already exists."

### Execution

```bash
$ make
go fmt ./...
go vet ./...
go build
```

Running `make` invokes the default goal (`build`), which transitively pulls in `vet` and `fmt`.

You can also invoke a specific target: `make fmt`, `make vet`.

## Examples

The example above (Go toolchain wrapped in `make`) is the canonical case: a single command runs the full pre-commit pipeline, with each step guaranteed to run before the next.

The same pattern adapts trivially:

```makefile
.DEFAULT_GOAL := test
.PHONY: install lint test

install:
	npm ci

lint: install
	npm run lint

test: lint
	npm test
```

## Trade-offs

- **For:** universal availability on Unix, zero install on Linux/macOS, language-agnostic, decades of muscle memory across the industry.
- **Against:** tab-vs-space gotcha, awkward shell semantics (each command runs in its own subshell unless you use `\` continuations), not installed by default on Windows, no native parallelism semantics beyond `-j`.
- **Modern alternatives:** `just`, `task`, `mage` (Go-native). Worth investigating but Make remains the default contract.

## Related

- [[go-toolchain]] — the canonical use case in Go projects.

## Sources

- [[learning-go-ch00-environment-setup]] (`raw/books/Learning Go/00_Setting up your go environment.md`)
