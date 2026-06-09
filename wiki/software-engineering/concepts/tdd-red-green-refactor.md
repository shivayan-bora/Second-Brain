---
title: "TDD — Red, Green, Refactor"
pillar: software-engineering
type: concept
tags: [testing, tdd, practice, methodology]
status: stable
sources: ["[[learn-go-with-tests-01-hello-world]]"]
created: 2026-06-09
updated: 2026-06-09
---

# TDD — Red, Green, Refactor

## Definition

**Red, Green, Refactor** is the TDD micro-cycle: (1) write a failing test (**Red**), (2) make it pass with the minimum code necessary (**Green**), (3) clean up with the test as your safety net (**Refactor**). Repeat until the feature is done.

## Why it matters

The cycle is not just about catching bugs. Its real value is the design pressure each step applies:

- **Red** forces you to write a usable API *before* you implement it — you become the first consumer of your own code.
- **Green** forces you to keep changes small. Big leaps fail loudly.
- **Refactor** is the only step where you change shape, and you do it with the test as a contract. If the test still passes, the behaviour didn't change.

For a staff-level reviewer, recognizing whether a change shows TDD discipline (small commits, test-then-implementation order) is a fast signal of how confidently future refactors will land.

## Mechanics

The *Learn Go with Tests* ch01 progression is a textbook TDD walkthrough:

1. **Red**: write `TestHello` expecting `"Hello, world"`. The `Hello()` function doesn't exist yet — compile fails.
2. **Green**: implement `Hello() string { return "Hello, world" }`. Test passes.
3. **Red**: add a subtest expecting `Hello("")` to return `"Hello, World"`. Test fails — `Hello` doesn't take an argument.
4. **Green**: change `Hello(name string) string` with an empty-string default. Test passes.
5. **Refactor**: extract `assertCorrectMessage` helper. Tests still pass — refactor confirmed safe.
6. **Red**: add Spanish/French subtests. Fails — `Hello` doesn't know about languages.
7. **Green**: add `language` parameter and `greetingPrefix` switch. Tests pass.
8. **Refactor**: introduce grouped constants for the prefix literals; promote `greetingPrefix` to use named returns.

Each step is a single, small change. The test suite is the contract that survives between steps.

## When the cycle helps most

- **API design** — TDD forces you to use the function before you implement it. Awkward APIs surface as awkward tests.
- **Regressions** — every behavioural step you take leaves a test behind. The wall of tests is the regression net.
- **Refactoring** — only the Refactor step changes shape; you only attempt it when Green is solid.

## When to suspend it

- **Spiking unfamiliar territory.** When you don't know what shape the code should take, exploratory code first (no tests), then throw it away and TDD the real version.
- **UI work where automation cost > test value.** Visual regressions, animation tuning, etc.
- **Glue / integration code dominated by external behavior.** Manual smoke tests + a thin contract test often beat trying to mock everything.

## Related

- [[go-testing-package]] — the engine for Go TDD.
- [[go-subtests]] — one common shape for the Red step's "next case".
- [[go-test-helpers]] — the Refactor step often extracts these.

## Open questions

- Cross-pillar link target: a soft-skills page on **feedback loops** would pair well with this — the same cognitive pattern (fast loop → confident change) shows up in learning, performance, and product. Worth creating when the soft-skills pillar gets its first content.

## Sources

- [[learn-go-with-tests-01-hello-world]] — quii's whole pedagogy is the cycle in action.
