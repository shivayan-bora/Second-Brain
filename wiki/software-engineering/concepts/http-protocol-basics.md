---
title: HTTP Protocol Basics (HTTP/1.1 Wire Format)
pillar: software-engineering
type: concept
tags: [http, networking, protocols, web]
status: in-progress
sources: ["[[project-byo-http-server-typescript]]"]
created: 2026-05-17
updated: 2026-05-17
---

# HTTP Protocol Basics (HTTP/1.1 Wire Format)

## Definition

**HTTP/1.1** is a text-based, request-response protocol layered on top of [[tcp-sockets|TCP]]. An HTTP message — request or response — is a sequence of bytes with a strict three-part structure separated by **CRLF (`\r\n`)**:

1. A **start line** (request line for requests; status line for responses).
2. Zero or more **header lines**, each terminated by `\r\n`.
3. A blank line (`\r\n` on its own), followed by an **optional body**.

## Why it matters

Almost every web framework hides the wire format. Implementing an HTTP server from raw [[tcp-sockets|TCP sockets]] forces the abstraction open and reveals that:

- HTTP is just bytes on a socket with a grammar — no magic.
- Bugs that show up in production (mysterious 400s, "header injection", subtle response truncation) usually live at the wire-format layer.
- The framing rules (`Content-Length`, chunked encoding, CRLF discipline) are exactly the rules a Staff Engineer needs to reason about edge cases at this layer.

## Mechanics

### Request structure

```
GET /index.html HTTP/1.1\r\n
Host: localhost:4221\r\n
User-Agent: curl/7.64.1\r\n
Accept: */*\r\n
\r\n
<optional body>
```

- **Request line:** `METHOD SP request-target SP HTTP-version CRLF`
  - Method: `GET`, `POST`, `PUT`, `DELETE`, etc.
  - Request target: path + optional query (e.g. `/echo/abc`).
  - Version: `HTTP/1.1`.
- **Headers:** `Name: value CRLF` lines. Case-insensitive names.
- **Blank line** (`\r\n`) separates headers from body.
- **Body** is optional and only present for methods/headers that imply it.

### Response structure

```
HTTP/1.1 200 OK\r\n
Content-Type: text/plain\r\n
Content-Length: 3\r\n
\r\n
abc
```

- **Status line:** `HTTP-version SP status-code SP reason-phrase CRLF`
  - Reason phrase is optional and informational; clients should not parse it.
- **Headers** and **body** as above.

### The minimal valid response

```
HTTP/1.1 200 OK\r\n\r\n
```

Status line, then the blank line. No headers, no body. Any HTTP/1.1 client will accept this.

### `Content-Type` and `Content-Length`

For responses with a body, two headers matter most:

- **`Content-Type`** — declares the media type (`text/plain`, `application/json`, ...). Clients use this to choose how to render the bytes.
- **`Content-Length`** — declares the body size **in bytes**, not characters. This is a trap for UTF-8 strings: `"é".length === 1` in JavaScript but the UTF-8 encoding is 2 bytes. Use `Buffer.byteLength(body)` in Node.

### Routing is string parsing

Without a framework, "routing" reduces to inspecting the request line:

```ts
const path = data.toString().trim().split(" ")[1]; // second token = request target
```

That's all `app.get('/foo', ...)` ultimately does — wrap this with a registry of routes.

## Examples

A minimal `/echo/{str}` response built byte-by-byte:

```ts
socket.write(
  `HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\nContent-Length: ${
    parameter.length
  }\r\n\r\n${parameter}\r\n`,
);
```

(Note: `parameter.length` is character count — fine for ASCII paths, wrong for multi-byte input.)

## Edge cases worth knowing

- **TCP fragmentation.** A single HTTP request may arrive split across multiple `data` events. Real parsers buffer until they see the end-of-headers `\r\n\r\n`.
- **`Connection: keep-alive`.** HTTP/1.1 connections are persistent by default — the same socket can carry multiple request/response pairs. Naive "close after one response" implementations break this.
- **Chunked transfer encoding.** When body size isn't known upfront, `Transfer-Encoding: chunked` replaces `Content-Length`.
- **Header injection.** If user input is interpolated into a header without sanitizing CRLFs, an attacker can inject extra headers or even an entire fake response. This is a real CVE class.

## Related

- [[tcp-sockets]] — the layer HTTP sits on.
- [[project-byo-http-server-typescript]] — implementing this from scratch in Node.

## Sources

- [[project-byo-http-server-typescript]] (`raw/projects/Build your own HTTP Server in TypeScript.md`)
- MDN: https://developer.mozilla.org/en-US/docs/Web/HTTP
