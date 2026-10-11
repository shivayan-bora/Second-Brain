---
id: llm-workflow-addy-osmani
aliases: []
tags:
  - article
creation date: 2026-10-11 11:41
modification date: "Sunday 11th October 2026 11:41:46"
source: https://addyosmani.com/blog/ai-coding-workflow/
status:
  - in-progress
---

## Start with a clear plan (specs before code)

- Begin by defining the problem and planning a solution.
- The first step is brainstorming a detailed specification with the AI, then outlining a step-by-step plan, before writing any actual code.
  - Describe the idea and ask the [[Large Language Model (LLM)]] to iteratively ask questions until the requirements and edge cases are fleshed out.
  - Compile this into a comprehensive `spec.md` - containing requirements, architecture decisions, data models and even a testing strategy.
- Next step is to feed the spec into a reasoning-capable model and prompt it to generate a project plan:
  - Break the implementation into logical, bite-sized tasks or milestones.
  - Iterate on this plan - editing and asking the [[Artificical Intelligence (AI)]] to critique or refine it - until it's coherent and complete.
  - Only then we should start coding.
- This upfront investment might feel slow, but it pays off enormously.

## Break work into small, iterative chunks

- Scope management is everything - feed the LLM manageable tasks, not the whole codebase at once.
  - Avoid asking large and monolithic outputs.
  - Instead break the project into iterative steps or tickets and tackle them one by one.
- LLMs do best when given focused prompts: implement one function, fix one bug, add one feature at a time.
- The fix is to stop, back up, and split the problem into smaller pieces. Each iteration, we carry forward the context of what's built and incrementally add to it. This approach fits nicely with a [[Test-Driven Development (TDD)]] approach.

> [!NOTE]
> You can also generate a structured `prompt plan` file that contains a sequence of prompts for each task.

## Provide extensive context and guidance

- LLMs are only as good as the context you provide - show them the relevant code, docs and constraints.
- Make sure to feed the AI all the information it needs to perform well:
  - the code it should modify or refer to
  - project's technical constraints
  - any known pitfalls or preferred approaches
- Expert LLM users emphasize this `context packing` step e.g. doing a `brain dump` of everything that model should know before coding, including:
  - high-level goals and invariants
  - examples of good solutions
  - warnings about approaches to avoid
- Don't make AI operate on partial information as well as be mindful of the [[Token]] limits.
- [[AI Skills]] can help provide durable and reusable prompts.
- Finally, guide the AI with comments and rules inside the prompt.
  - e.g. you may precede a code snippet with `Here's the current implementation of X. We need to extend it to do Y, but be careful not to break Z.`

## Choose the right model (and use multiple when needed)

- Not all coding LLMs are equal - pick your tool with intention.
- Also, make sure you're using the best version available. While they might consume more tokens, their outputs may be far superior. Depending on the task, choose the best model and it's version available.

> [!WARNING]
> Don't change models mid-stream because of token costs. When we switch models mid-stream, the new model needs to rebuilt it's cache from scratch and that consumes a shit ton of token.
