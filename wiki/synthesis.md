# Synthesis

Running answer to: what does the user currently know/believe about being a staff engineer? Updated sparingly — only when a source materially shifts the picture.

## Software Engineering

- **Design systems are a discipline, not a component library.** The first source ([[design-systems-storybook-v2]]) shows the real work is layered abstraction (raw values → [[design-tokens]] → component aliases) and constraining choice, not just building reusable components. Naming and cross-team (design/eng) collaboration are called out as the genuinely hard parts — harder than any tooling choice.
- [[storybook]] and [[class-variance-authority]] are the concrete tools that make this workable in a codebase: isolated, testable component variants with a schema (cva) and a documentation/testing harness (Storybook) sitting on top of it.
- Too early to generalize further — one source in.
