---
id: Claude Code Deep Dive
aliases: []
tags:
  - course
creation date: 2026-07-02 10:53
modification date: Thursday 2nd July 2026 10:53:59
source: https://master.dev/courses/claude-code/
status:
  - in-progress
---

## Claude Code under the Hood

### Available Models

![[Pasted image 20260702105548.png]]

- Opus (most capable, best for deep reasoning and complex problems, but slowest and most expensive), Sonnet (balanced capability, speed, and cost - ideal for general software engineering tasks like building features and fixing bugs), and Haiku (fast and cheap, good for tasks that don't require reasoning like refactoring or renaming functions).
- Effort is how much you want the model to think or how much effort does the model put in.

### Models and Harnesses

![[Pasted image 20260702105418.png]]

- Models are stateless. Harness provides the state.
- The model has no in-session memory and no memory between calls. Every time the model is called, it starts from zero. The harness must provide all the state, including files, conversation history, environment setup, and other context through the assembled prompt.
- The harness (Claude Code itself, which runs on desktop, web, or other platforms) and the model (either Opus, Sonnet, or Haiku). The model cannot directly interact with your machine - it can only reason about prompts. The harness is responsible for exposing tools, shell commands, and your codebase to the model.

### Agentic Loop

- The four main components of an assembled prompt in Claude Code:
  - Tool schemas (JSON schemas defining actions like bash, edit, read, web fetch)
  - System prompts (hard-coded instructions about the model's identity, tone, coding conventions, and security rules)
  - Environment information (operating system, shell, model type, git branch)
  - Messages array (conversation history including prompts, `claude.md` file contents, and skill lists).

- The agentic loop is the continuous back-and-forth process between the harness (Claude Code) and the API/model. The model sends tool calls to the harness, the harness executes them and returns tool results, and this process repeats. The loop ends when the model responds with just text instead of a tool call, signaling it doesn't need to perform any more actions.

> [!NOTE]
> Ideally you shouldn't switch models in-between a session as it breaks the prompt cache causing the cache to rebuild which can be even more expensive.

> [!TIP]
> Sometimes using a cheaper model may not be cheaper as such e.g. you may be having a lot of back-and-forth with Sonnet because it can't get something right where Opus might've one shotted the feature.
> You can start with the Sonnet and only switch to Opus if there's something that it can't get right.

## CLAUDE.md and Plan Mode

- The `CLAUDE.md` file provides context to the AI model about the project's structure, conventions, technologies used, commands, architecture, and data flow. It helps reduce the number of tool calls by giving the model upfront information about the codebase, preventing it from needing to make additional queries to understand basic project details.
- You can generate the `CLAUDE.md` file by running the `/init` command.
  - This explores the codebase, understands conventions and structures, and creates a `CLAUDE.md` file based on that analysis.
- `CLAUDE.md` is the first thing that gets added to the user prompt.
  - If you have to repeat something in your prompt multiple times, put it in the `CLAUDE.md` file.
  - If we have a really large CLAUDE.md file and most of it isn't being used by the model, you'll go through your tokens much faster.
- You can check your current context and your context window with `/context`.
- `/plan` mode (or you can put in the prompt as well), is useful for brainstorming about a feature and plan the implementation before starting to code.

## Permissions

- Permissions can be added at the global level or at the project level.

```json
/* /project/.claude/settings.json */
{
  "permissions": {
    // Array of permission rules to allow tool use
    "allow": ["Bash(npm run *)", "Bash(git commit *)"],

    // Array of permission rules to deny tool use
    "deny": ["Bash(git push *)"],

    // Array of permission rules to ask confirmation before tool use
    "ask": ["Bash(rm *)", "Bash(mv *)"],

    // "default", "plan", "auto", "dontAsk", "bypassPermissions"
    "defaultMode": "acceptEdits"
  }
}
```

- To interactively edit your permissions from within a Claude Code session, run the `/permissions` command.
- `/fewer-permission-prompts` goes through your transcripts and find the tool calls we accessed the most.
  - It analyzes your previous Claude Code sessions, identifies tool calls that you've frequently accepted, and automatically adds them to your permissions settings to reduce repetitive prompting.
- You can modify org-wide permissions as well using [server-managed settings](https://code.claude.com/docs/en/server-managed-settings#configure-server-managed-settings)
- Order of precedence for permissions: server-managed-settings => Global => Project => User

## Effort and Context Windows

- `/advisor` enables the Advisor Mode.
  - Advisor mode allows you to use a different model (like Opus) specifically for planning tasks while remaining on another model (like Sonnet) for implementation. This lets you leverage the deeper reasoning capabilities of one model for planning without having to manually switch models.
- As of Opus 4.6, the four effort levels are low, medium, high, and max. These levels control the amount of thinking and reasoning the model will do for a specific prompt. The effort level gets appended to the prompt so the model understands how deeply it should reason.
- Sometimes the model might refuse to do tasks or appear lazy in it's responses:
  - The effort level may be set too low (medium or low instead of high or max). Before switching to a different model like Opus or Haiku, adjusting the effort level can often resolve the issue.
- Setting the effort level to max provides deeper reasoning but results in higher inference costs and more expensive usage. The model may also overthink simple tasks that don't require extensive reasoning.

## Skills

- Skills are reusable, structured, project-specific instructions (workflows or reference)
  - It's just a markdown file with a specific procedure.
- You can view a list of skills via the command: `/skills`
- You can create new skills using `/skill-creator`
  - Skill Creator is used to automatically create skills and can also check if a skill actually improves workflow performance. It runs evaluations (`evals`) on skills to test how the codebase performs with and without the skill, ensuring that added skills actually improve the code rather than just adding unnecessary tokens.
- If you have a Claude Code session open and you added a new skill, you need to run the command `/reload-plugins` to load the skill into the current session.
- Read the [Skills Documentation](https://code.claude.com/docs/en/skills) and [advanced patterns](https://code.claude.com/docs/en/skills#advanced-patterns) for more information.
- Use `/insights` skill to check how well you've been doing with Claude Code.
- `powerup`: Discover Claude Code features through quick interactive lessons

> [!TIP]
> Using `@` in prompts to reference files attaches the file directly to the prompt itself, which reduces or removes one tool call (like read or write operations). This makes the interaction more efficient by including the file context upfront rather than requiring Claude to make an additional tool call to access it.

> [!TIP]
> While creating skills, the `when_to_use` field provides additional context specifically for the model to understand when to invoke a particular skill. While the description field helps both users and the model (and is visible in the CLI), the `when_to_use` field gives even more precision for the model without cluttering the user-facing description.

> [!TIP]
> Using `context_fork` in a skill configuration makes the skill run in a sub-agent rather than the main context. The sub-agent runs in parallel with a brand new context, and only the results are returned to the main conversation. This prevents the main context from being cluttered with intermediate tool calls and can improve the quality of model output.

## Hooks

- We can run custom logic automatically at defined points in Claude Code's lifecycle. Hooks allow us to hook into these lifecycle methods.

![[Pasted image 20260704165157.png]]
