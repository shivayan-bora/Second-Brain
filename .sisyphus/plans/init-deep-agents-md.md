# Generate AGENTS.md for Second-Brain Vault

## TL;DR

> **Quick Summary**: Write a single root-level AGENTS.md file for this Obsidian knowledge vault. All content is pre-written below — this is a copy-paste execution task.
>
> **Deliverables**:
> - `./AGENTS.md` — Root project knowledge base file
>
> **Estimated Effort**: Quick (single file write)
> **Parallel Execution**: NO — single task
> **Critical Path**: Task 1 only

---

## Context

### Original Request

`/init-deep` — Generate hierarchical AGENTS.md knowledge base files.

### Research Findings

- **Project type**: Obsidian knowledge vault (Second Brain / Zettelkasten), NOT a code project
- **~142 files** total: ~100+ markdown notes, ~27 images, ~30 Obsidian config JSONs
- **No existing AGENTS.md or CLAUDE.md** anywhere in the vault
- **17 topic directories** under `02_notes/` — all follow identical conventions
- **No source code** — only Obsidian plugin bundles in `.obsidian/`
- **No build/CI/tests** — pure knowledge management system
- **Scoring result**: Only root AGENTS.md warranted. No subdirectory has unique conventions.

### Key Conventions Discovered

1. **YAML frontmatter** on all notes: creation date, modification date, tags, status
2. **MOC pattern**: Index files tagged `moc` linking to sub-notes via `[[wikilinks]]`
3. **Numbered prefix folders**: `00_templates`, `01_projects`, `02_notes`, `03_assets`
4. **Linter enforced on save**: Title Case headings, 2-space tabs, blank lines around blocks
5. **Vim mode** with custom `.obsidian.vimrc`, JetBrainsMono Nerd Font, Rose Pine theme
6. **Smart Connections**: BGE-micro-v2 embeddings + Ollama deepseek-r1:32b for AI chat
7. **Daily notes** go to `01_projects/UiPath/Progress/`, NOT `02_notes/daily/` (that folder is empty)

---

## Work Objectives

### Core Objective

Write `./AGENTS.md` with the exact content specified below.

### Concrete Deliverables

- `./AGENTS.md` (root) — ~130 lines

### Definition of Done

- [ ] `./AGENTS.md` exists at project root
- [ ] File content matches the specification below exactly

### Must Have

- Single AGENTS.md at root
- All conventions, anti-patterns, and structure documented

### Must NOT Have (Guardrails)

- NO AGENTS.md in subdirectories (would pollute Obsidian vault graph)
- NO generic advice (e.g., "write clean code")
- NO obvious information (e.g., "markdown files end in .md")

---

## Verification Strategy

### Test Decision

- **Infrastructure exists**: NO
- **Automated tests**: None
- **Framework**: None

### Agent-Executed QA Scenarios

```
Scenario: AGENTS.md exists at root
  Tool: Bash
  Steps:
    1. test -f ./AGENTS.md && echo "EXISTS" || echo "MISSING"
  Expected Result: "EXISTS"

Scenario: File is non-empty and reasonable size
  Tool: Bash
  Steps:
    1. wc -l ./AGENTS.md
  Expected Result: Between 100-150 lines

Scenario: Key sections present
  Tool: Bash (grep)
  Steps:
    1. grep -c "## STRUCTURE" AGENTS.md
    2. grep -c "## WHERE TO LOOK" AGENTS.md
    3. grep -c "## CONVENTIONS" AGENTS.md
    4. grep -c "## ANTI-PATTERNS" AGENTS.md
  Expected Result: Each returns 1
```

---

## Execution Strategy

Single task, no parallelization needed.

---

## TODOs

- [ ] 1. Write `./AGENTS.md` with exact content below

  **What to do**:
  Write the file `./AGENTS.md` at the project root with the EXACT content from the `## AGENTS.md CONTENT` section below. Use the Write tool. Single file, single write.

  **Must NOT do**:
  - Do NOT create AGENTS.md in any subdirectory
  - Do NOT modify any existing vault files
  - Do NOT add the file to `.obsidian/` or any config

  **Recommended Agent Profile**:
  - **Category**: `quick`
    - Reason: Single file write, content fully pre-written
  - **Skills**: []
    - No special skills needed — just a file write

  **Parallelization**:
  - **Can Run In Parallel**: NO
  - **Parallel Group**: N/A (single task)
  - **Blocks**: Nothing
  - **Blocked By**: None

  **References**:
  - Content fully specified below — no external references needed

  **Acceptance Criteria**:
  - [ ] File exists: `./AGENTS.md`
  - [ ] Contains `# PROJECT KNOWLEDGE BASE` as first heading
  - [ ] Contains all 7 major sections: STRUCTURE, WHERE TO LOOK, CONVENTIONS, ANTI-PATTERNS, PLUGINS, AI INTEGRATION, NOTES
  - [ ] Between 100-150 lines

  **Commit**: YES
  - Message: `docs: add AGENTS.md knowledge base for Second-Brain vault`
  - Files: `AGENTS.md`

---

## AGENTS.md CONTENT

Write this EXACT content to `./AGENTS.md`:

~~~markdown
# PROJECT KNOWLEDGE BASE

**Type:** Obsidian Knowledge Vault (Second Brain / Zettelkasten)
**Stack:** Markdown + Obsidian + Smart Connections (Ollama deepseek-r1:32b) + Templater
**NOT a code project.** No source code, no build tools, no tests, no CI/CD.

## STRUCTURE

```
Second-Brain/
├── 00_templates/           # 3 templates (Daily Note, Note, Project)
├── 01_projects/            # Active learning projects + UiPath work
│   └── UiPath/Progress/    # Daily progress notes (daily-notes target)
├── 02_notes/               # Knowledge base: 17 topic directories
│   ├── angular/ (11)       # Angular framework notes
│   ├── astro/ (1)          # Astro.js
│   ├── c/ (5)              # C language + assembly
│   ├── computer-science/ (4) # CS fundamentals
│   ├── daily/ (empty)      # UNUSED - daily notes go to UiPath/Progress
│   ├── dotnet/ (5)         # .NET ecosystem
│   ├── gen-ai/ (2)         # ML + generative AI
│   ├── golang/ (17)        # Go language (largest topic)
│   ├── html-css/ (2)       # HTML/CSS
│   ├── javascript/ (3)     # JavaScript
│   ├── linux/ (4)          # Linux + shell
│   ├── networks/ (1)       # Networking
│   ├── node.js/ (3)        # Node.js
│   ├── python/ (16)        # Python (second largest)
│   ├── react/ (5)          # React
│   ├── rxjs/ (1)           # RxJS
│   └── typescript/ (5)     # TypeScript
├── 03_assets/              # Pasted images (attachment folder)
├── copilot/                # 13 Obsidian Copilot custom prompts
│   └── copilot-custom-prompts/
├── .obsidian/              # Vault config + 11 community plugins
├── .smart-env/             # AI embeddings cache + chat threads
├── .obsidian.vimrc         # Vim keybindings
└── Untitled.md             # Stray file (scratch pad)
```

## WHERE TO LOOK

| Task | Location | Notes |
|------|----------|-------|
| Add a new topic | `02_notes/{topic-slug}/` | Create index MOC file + sub-notes |
| Add a learning project | `01_projects/` | Use Project Template |
| Create a note | `02_notes/{topic}/` | Use Note Template |
| Daily progress | `01_projects/UiPath/Progress/` | Auto-created by daily-notes plugin |
| Add images | `03_assets/` | Configured in app.json `attachmentFolderPath` |
| Edit templates | `00_templates/` | Uses Templater `tp.file.*` syntax |
| AI/copilot prompts | `copilot/copilot-custom-prompts/` | Special Copilot YAML frontmatter |
| Vault settings | `.obsidian/app.json` | Vim mode, line numbers, link updates |
| Linter rules | `.obsidian/plugins/obsidian-linter/data.json` | Enforced on save |
| Smart Connections | `.smart-env/smart_env.json` | Ollama + embedding config |

## CONVENTIONS

### YAML Frontmatter (ALL Notes)

Every note MUST have:

```yaml
---
creation date: <Templater-generated timestamp>
modification date: <Templater-generated timestamp>
tags:
  - note|project|daily    # Type tag
  - <topic-slug>          # Topic tag (go, angular, python, etc.)
  - moc                   # ONLY on index/MOC files
status:
  - active
---
```

Templates use `<% tp.file.creation_date("dddd Do MMMM YYYY HH:mm:ss") %>`.

### MOC (Map of Content) Pattern

Topic index files (Go.md, Angular.md, Python.md):
1. Tagged with `moc` in addition to `note` + topic slug
2. Start with `# References` section (external links)
3. Brief overview of topic
4. End with `## Topics` / `## Contents` listing `[[wikilinks]]` to sub-notes

### Wikilinks

- Cross-reference: `[[Note Title]]`
- Aliased: `[[Concurrency vs Parallelism|concurrent programming]]`
- Internal links = wikilinks always; external URLs = markdown links

### Linter Rules (Enforced on Save)

- **Headings**: Title Case (ignores: macOS, iOS, JavaScript, TypeScript, etc.)
- **Indentation**: Tabs, tabsize 2
- **Spacing**: Blank lines around blockquotes, code fences, tables, headings, math blocks
- **Trailing**: Remove trailing spaces, newline at EOF
- **Lists**: Space after markers, no empty lines between items

### Editor

- Vim mode with `.obsidian.vimrc` (j/k = visual lines, H/L = bol/eol, ]b/[b = tabs)
- Font: JetBrainsMono Nerd Font (15px)
- Theme: Rose Pine
- Attachments auto-saved to `03_assets/`

## ANTI-PATTERNS

- **DO NOT** place daily notes in `02_notes/daily/` — empty/unused; target is `01_projects/UiPath/Progress/`
- **DO NOT** use `[text](url)` for internal vault links — use `[[wikilinks]]`
- **DO NOT** create notes without YAML frontmatter (creation date, modification date, tags, status)
- **DO NOT** omit the `moc` tag on topic index files
- **DO NOT** use lowercase headings — linter enforces Title Case
- **DO NOT** check Python object immutability via `value` property — use `id` instead

## PLUGINS (11 Community)

| Plugin | Purpose |
|--------|---------|
| omnisearch | Full-text search (Cmd+O global, Cmd+F in-file) |
| templater-obsidian | Dynamic templates with `tp.*` syntax |
| obsidian-icon-folder | Custom folder icons |
| tag-wrangler | Tag management |
| obsidian-linter | Markdown formatting (lint on save) |
| obsidian-mind-map | Mind map visualization |
| smart-connections | AI semantic search (BGE-micro-v2 + Ollama chat) |
| obsidian-plugin-toc | Table of contents generation |
| obsidian-relative-line-numbers | Relative line numbers |
| obsidian-vimrc-support | .obsidian.vimrc keybindings |
| obsidian-local-rest-api | REST API for external tools |

## AI INTEGRATION

- **Embeddings**: TaylorAI/bge-micro-v2 (min 200 chars per block)
- **Chat**: Ollama deepseek-r1:32b at `http://localhost:11434`
- **Copilot**: 13 custom prompts in `copilot/copilot-custom-prompts/`
- **Cache**: `.smart-env/multi/` (~171 .ajson files)

## NOTES

- No git repo initialized
- `02_notes/daily/` is empty — daily notes go to `01_projects/UiPath/Progress/`
- Largest topics: golang (17), python (16), angular (11)
- Projects track learning: Frontend Masters, CodeCrafters, boot.dev
- Notes contain code snippets but vault has zero standalone source files
~~~

---

## Commit Strategy

| After Task | Message | Files | Verification |
|------------|---------|-------|--------------|
| 1 | `docs: add AGENTS.md knowledge base for Second-Brain vault` | AGENTS.md | `test -f AGENTS.md` |

---

## Success Criteria

### Verification Commands

```bash
test -f AGENTS.md && echo "OK"           # Expected: OK
wc -l AGENTS.md                           # Expected: 100-150 lines
grep -c "## STRUCTURE" AGENTS.md          # Expected: 1
grep -c "## ANTI-PATTERNS" AGENTS.md      # Expected: 1
```

### Final Checklist

- [ ] `AGENTS.md` exists at project root
- [ ] Contains all required sections
- [ ] No AGENTS.md in subdirectories
- [ ] No generic advice or obvious information
- [ ] Between 100-150 lines, telegraphic style
