# CLAUDE.md — Staff Engineer Journey Wiki

## Purpose

This repo is a personal **LLM-maintained wiki** for the user's staff software engineer journey. The user curates sources, asks questions, and directs synthesis. **You (the LLM) own all wiki maintenance** — ingesting sources, writing pages, updating cross-references, keeping things coherent.

The wiki has three pillars. Every page belongs to one of them as its **primary** pillar (cross-link the others):

1. **Software Engineering** — technical depth: languages, systems, architecture, code quality, testing, performance, distributed systems.
2. **Leadership** — staff-engineer leadership: technical strategy, archetypes (Tech Lead, Architect, Solver, Right Hand), influence without authority, sponsoring others.
3. **Soft Skills** — communication, writing, feedback, conflict, mentorship, presenting, navigating ambiguity.

## Architecture

- **`raw/`** — immutable source documents. Read-only. Never modify.
- **`wiki/`** — LLM-managed pages. You own this layer entirely.
- **`CLAUDE.md`** — this schema. Co-evolve it with the user as conventions firm up.
- **`templates/`** — Obsidian Templater files for raw notes. Don't touch from the LLM side; the user uses these when creating new raw notes in Obsidian.
- **`assets/`** — images and binary attachments.

`raw/` subdirs: `articles/`, `books/`, `courses/`, `documentation/`, `projects/`, `videos/`.

## Wiki Directory Layout

```
wiki/
├── index.md          # catalog of all pages — update on every ingest
├── log.md            # append-only chronological log
├── synthesis.md      # evolving overview / running thesis
├── software-engineering/
│   ├── concepts/     # abstract ideas (e.g., go-modules.md)
│   ├── patterns/     # practices (e.g., trunk-based-development.md)
│   └── summaries/    # one per ingested source/chapter
├── leadership/
│   ├── concepts/     # e.g., technical-strategy.md
│   ├── archetypes/   # e.g., tech-lead.md, architect.md
│   └── summaries/    # one per ingested source/chapter
└── soft-skills/
    ├── concepts/     # comms, feedback, influence
    └── summaries/    # one per ingested source/chapter
```

## Conventions

### Filenames
- **kebab-case** for wiki pages: `go-modules.md`, `tech-lead-archetype.md`.
- Source summaries: `{source-slug}-ch{NN}-{topic-slug}.md` for chapters, `{source-slug}.md` for whole sources.

### Frontmatter
Every wiki page gets YAML frontmatter:

```yaml
---
title: Go Modules
pillar: software-engineering         # software-engineering | leadership | soft-skills
type: concept                        # concept | pattern | archetype | summary
tags: [go, dependency-management]
status: in-progress                  # in-progress | stable | contested | stale
sources: ["[[learning-go-ch00-environment-setup]]"]
created: 2026-05-17
updated: 2026-05-17
---
```

#### `source:` / `former_source:` / `points-to:` conventions

- **`source:`** — the canonical raw-side counterpart of a wiki page. Should be **unique per raw file**: at most one wiki page claims a given raw path. Summaries always have one; concepts and patterns usually don't (they cite their feeding summaries via `sources:` instead).
- **`former_source:` + `source_status: deleted`** — when a raw source has been removed from the vault but the wiki notes are retained, replace `source:` with this pair. The wiki page is "orphaned from its raw" but still valuable as a record of prior understanding. Add a `> [!NOTE] Raw source deleted` callout in the body pointing at the change.
- **`points-to:`** — for **hub-summary pages** (tagged `[hub]`) whose underlying raw is *also* already covered by a substantive summary. The hub becomes a pointer page that aliases the substantive summary; it does not claim `source:` (uniqueness preserved). The body is a brief navigation alias rather than a full hub catalog. See [[pnpm-io-hub]], [[radix-ui-hub]], [[fm-design-systems-storybook-v2-hub]] for the pattern in practice.

In short: every raw file is claimed by at most one wiki page (via `source:`), and the wiki graph is the source of truth for which raw is currently live vs. deleted vs. summarized-elsewhere.

### Wikilinks
- Use `[[page-name]]` or `[[page-name|display text]]` everywhere inside `wiki/`. This matches the user's existing Obsidian style in `raw/`.
- Prefer wikilinks over markdown links for internal references.
- Write `[[link]]` even when the target page doesn't exist yet. Orphan links surface gaps; the lint pass catches them.
- **Raw-side cross-vault links are allowed.** Brand or hub references like `[[TypeScript]]`, `[[React]]`, `[[Node.js]]`, `[[Eloquent JavaScript]]`, `[[Learning Go]]`, `[[CLAUDE]]`, `[[babel]]` resolve to raw-side hub files (or the schema), not wiki pages. The lint pass should categorize these separately rather than flag them as "missing wiki pages." Convention: use the raw file's existing title verbatim (PascalCase, spaces preserved).

### Tags (extend the user's existing taxonomy in `raw/`)
- Source-type tags carried over: `book`, `chapter`, `article`, `course`, `video`, `documentation`, `project`.
- Wiki page-type tags: `concept`, `pattern`, `archetype`, `summary`.
- Domain tags: free-form, lowercase, kebab-case (`go`, `concurrency`, `feedback`, `staff-engineer`).

### Status vocabulary
- `in-progress` — actively being built or source not fully ingested.
- `stable` — mature; reflects current understanding.
- `contested` — sources disagree; the page documents the disagreement.
- `stale` — known to be out of date; flag for re-ingest.

## Page Templates

### Summary page — `wiki/{pillar}/summaries/{slug}.md`
One per ingested source or chapter. Sections:
1. **TL;DR** — 3-5 bullets.
2. **Key takeaways** — substantive points, each with `[[concept-page]]` links.
3. **Notable quotes / passages** — verbatim, with citation back to the raw file path.
4. **Open questions** — things to investigate later.
5. **Cross-references** — `[[other-summaries]]` this relates to.

### Concept page — `wiki/{pillar}/concepts/{slug}.md`
One per distinct idea. Sections:
1. **Definition** — one paragraph.
2. **Why it matters** — connect to the staff-eng journey.
3. **Mechanics / details** — the substantive content.
4. **Examples** — concrete cases (code, scenarios).
5. **Related** — `[[other-concepts]]`.
6. **Sources** — which raw sources contributed (linked).

### Pattern page — `wiki/software-engineering/patterns/{slug}.md`
Sections: Context, Problem, Solution, Trade-offs, Sources.

### Archetype page — `wiki/leadership/archetypes/{slug}.md`
Sections: Description, Scope, Day-to-day, When it fits, Sources.

## Operations

### Ingest
When the user points you to a new raw source:

1. **Read** the source in `raw/`.
2. **Discuss** key takeaways with the user — confirm what to emphasize and what to skip.
3. **Decide the primary pillar** (software-engineering / leadership / soft-skills).
4. **List** the concept/pattern/archetype pages you plan to create or update. Get a thumbs-up before writing.
5. **Write the summary page** in `wiki/{pillar}/summaries/`.
6. **Create or update concept pages** for each substantive idea (typically 2-6 per chapter).
7. **Update `wiki/index.md`** with new entries under the right pillar/type.
8. **Append to `wiki/log.md`** with a parseable entry.
9. **Update `wiki/synthesis.md`** only if the source materially shifts the running thesis.

Stay involved. Don't batch-ingest unless asked. One source at a time, discussed.

### Query
When the user asks a question:
1. **Read `wiki/index.md` first** to locate relevant pages.
2. **Read those wiki pages**; fall back to raw sources only if the wiki is insufficient.
3. **Answer with citations** — `[[wiki-page]]` for internal, `raw/...` path for raw sources.
4. **Offer to file the answer back** as a new page if it's a non-trivial synthesis, comparison, or analysis. Good answers shouldn't disappear into chat history.

### Lint
When the user asks for a health check, look for:
1. **Orphan pages** — no inbound `[[links]]`.
2. **Dangling wikilinks** — `[[X]]` with no target page.
3. **Stale status** — `stale` pages, or `updated:` >90 days old when newer sources have arrived.
4. **Contradictions** — pages claiming opposing things.
5. **Missing concept pages** — concepts mentioned ≥2 times across summaries but with no dedicated page.
6. **Coverage gaps** — pillars or topics the user wants to develop but hasn't sourced yet.

Report findings as a list of suggested actions; don't fix unilaterally.

## Special files

### `wiki/index.md`
Catalog. Organized by pillar, then by page type. Each entry: `- [[page-slug]] — one-line summary`. Update on every ingest.

### `wiki/log.md`
Append-only. Each entry starts with a parseable prefix:

```
## [YYYY-MM-DD] {ingest|query|lint|decision} | {short title}

- bullet of what changed
- ...
```

This lets `grep "^## \[" wiki/log.md | tail -10` work as a quick activity feed.

### `wiki/synthesis.md`
A short, evolving overview — your running answer to *"what does the user currently know/believe about being a staff engineer?"* Re-read before answering big questions. Update sparingly — only when a source materially shifts the picture.

## Style

- **Concise.** Bullets and short paragraphs over walls of text.
- **Cite.** Every non-obvious claim links its source.
- **Don't invent.** If a source doesn't support a claim, don't write it. Note it as an open question instead.
- **Preserve the user's voice.** When the user writes a first-person take in a wiki page, keep it clearly attributed (e.g., a `> [!NOTE]- My take` callout) and don't paraphrase the personality out of it.
- **Respect existing raw conventions.** `[[wikilinks]]`, lowercase tags, `in-progress`/`completed` status in raw files — match these in wiki frontmatter where applicable.

## Schema evolution

This file is meant to grow. When you and the user agree on a new convention mid-session, propose adding it here. When something in this schema turns out to be wrong, propose a change rather than silently deviating.
