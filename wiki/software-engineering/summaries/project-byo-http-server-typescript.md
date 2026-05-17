---
title: "Project — Build Your Own HTTP Server in TypeScript"
pillar: software-engineering
type: summary
tags: [project, typescript, http, tcp, networking, codecrafters]
status: in-progress
source: "raw/projects/Build your own HTTP Server in TypeScript.md"
project: "CodeCrafters — HTTP Server (TypeScript track)"
created: 2026-05-17
updated: 2026-05-17
---

# Project — Build Your Own HTTP Server in TypeScript

CodeCrafters "Build Your Own X" walkthrough: implement an HTTP/1.1 server from scratch in [[TypeScript]] on top of [[Node.js]]'s `net` module — i.e. starting from raw [[tcp-sockets|TCP sockets]] rather than `http.createServer`. The point is to *feel* the wire format and the protocol boundaries that frameworks normally hide.

## TL;DR

- HTTP is a text protocol on top of [[tcp-sockets|TCP]]. Node's `net.createServer` gives you the raw socket; you write the response bytes yourself. See [[http-protocol-basics]].
- The structure of an HTTP/1.1 message is **three parts separated by CRLF (`\r\n`)**: start line, zero-or-more headers (each `\r\n`-terminated), blank line, optional body.
- A minimal valid 200 response is literally six characters of overhead plus the status line: `HTTP/1.1 200 OK\r\n\r\n`. There's no magic.
- Routing is just **string parsing of the request line** — split on spaces, inspect the second token (the request target), decide what to write back.
- Bodies require **two specific headers** to be well-formed for most clients: `Content-Type` and `Content-Length` (in bytes).

## What was built (progress so far)

- A [[tcp-sockets|TCP server]] bound to `localhost:4221` via `net.createServer`.
- A handler that responds `HTTP/1.1 200 OK\r\n\r\n` to any incoming connection.
- URL-path extraction from the raw request buffer (`data.toString().trim().split(" ")[1]`).
- Two routes: `/` returns 200, anything else returns 404.
- An `/echo/{str}` route that returns the path parameter as the body with correct `Content-Type` and `Content-Length` headers.
- *In progress:* reading individual request headers (`User-Agent`, etc.).

## Key takeaways

- **`net.createServer` is the foundation `http.createServer` is built on.** Going one layer down makes the framing explicit — you see that "an HTTP request" is just bytes on a socket that happen to follow a CRLF-delimited grammar. See [[http-protocol-basics]].
- **CRLF (`\r\n`) is load-bearing.** It separates start line from headers, header from header, and headers from body. Get it wrong and every client will reject the response.
- **`Content-Length` is in bytes, not characters.** Trivial for ASCII, a trap for multi-byte UTF-8. Worth remembering when bodies get real.
- **A `socket` is an abstraction over a TCP/IPC connection.** It emits events (`data`, `close`) and exposes `write()` to push bytes. The whole HTTP server boils down to: listen for `data`, parse it, call `write`. See [[tcp-sockets]].
- **Buffers vs strings.** Socket `data` callbacks receive `Buffer` (or string in some modes). Calling `.toString()` is fine for ASCII protocol bytes but lossy for binary bodies.

## Open questions

- How is `Connection: keep-alive` handled? The current implementation appears to handle a single request per socket — what changes for persistent connections?
- What's the right way to parse arbitrary request bodies (not just the request line)? Naive `split(" ")` breaks once headers contain spaces or the body contains CRLFs.
- How do real Node HTTP servers handle TCP packet fragmentation — i.e. what if a single HTTP request arrives across multiple `data` events?
- What does HTTP/2 framing look like by comparison? HTTP/1.1's text-and-CRLF design is famously ad-hoc; HTTP/2 is binary-framed.

## Cross-references

- Concepts introduced: [[http-protocol-basics]], [[tcp-sockets]]
- Source path: `raw/projects/Build your own HTTP Server in TypeScript.md`
- External: CodeCrafters HTTP Server course (TypeScript track) — https://app.codecrafters.io/courses/http-server
