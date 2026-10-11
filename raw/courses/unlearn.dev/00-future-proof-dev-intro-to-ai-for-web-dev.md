---
id: 00-future-proof-dev-intro-to-ai-for-web-dev
aliases: []
tags:
  - course
creation date: 2026-10-10 14:44
modification date: "Saturday 10th October 2026 14:44:57"
source: https://unlearn.dev/courses/the-future-proof-dev-an-intro-to-ai-for-web-developers/lesson/introduction-to-ai-for-web-developers?source=course_page
status:
  - completed
---

## What is AI (for developers)?

- [[Artificial Intelligence (AI)]] is a field of [[Computer Science]] that enables software to perform tasks typically requiring human intelligence e.g.
  - Understanding Language
  - Recognizing Patterns
  - Making Decisions
- Modern AI uses [[Machine Learning]] to analyze patterns in data.

### Large Language Models

- [[Generative AI]] is a system that learns to generate new objects resembling the data it was trained on.
  - e.g. [[ChatGPT]] was trained on large datasets of books, code and text by scraping data from all over the web. It is also known as a [[Large Language Model (LLM)]].
- LLMs take this data and learn the [[Statistics|statistical]] relationships between words, phrases and concepts. They learn how language typically flows, the [[Probability|probability]] that one word follows another.

#### Tokens

- It's not actually a word but a [[Token]].
- A **token** is the smallest unit of information defined by the model's tokenizer. It can be letters, complete or part of words and even punctuations.

#### Context Window

- **Context**, in simple terms, is the input we provide to the LLM to generate some response.
  - You can think of it as a short-term memory for your AI.
  - Some of the things it can contain in the context of a codebase:
    - Your current prompt.
    - Previous messages in the conversation.
    - Code, documentation, and files you or your Agent Harness e.g. [[Claude Code]] or [[Cursor]] has given it access to.
    - Contextual errors and warnings from tools like [[TypeScript]] and [[ESLint]].
  - Better Context === Better Outputs
- Calls to an LLM is stateless in nature like [[HTTP]] meaning you need to send the previous messages as well since an LLM can't remember what you have spoken with it.
- Naturally, there's a limit of maximum number of messages or tokens you can send to your LLM which is known as it's [[Context Window]]. Anything more than this context window and the model will truncate initial tokens thereby reducing the quality of outputs you receive from the LLM.
  - The model's response also counts towards this limit.

### AI Agents

- An LLM can output a response but it can never take actions. Think of it like a brain, it can think but by itself, it cannot perform tasks without limbs.
- This is where [[AI Agents]] come in. Think of agents as the limbs to your LLMs. These are specific tools given by your IDE, OS or an API endpoint.
  - e.g. Claude Code uses `grep` to read files, `touch` to create files, `cat` or `|` or `>>` operators to write to a file etc.
