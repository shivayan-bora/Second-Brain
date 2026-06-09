---
title: TCP Sockets (in Node.js)
pillar: software-engineering
type: concept
tags: [tcp, networking, node, protocols]
status: stable
sources: ["[[project-byo-http-server-typescript]]"]
created: 2026-05-17
updated: 2026-06-09
---

# TCP Sockets (in Node.js)

## Definition

A **TCP socket** is an abstraction over a single TCP connection between two endpoints. It is a bidirectional, ordered, byte-stream interface — you write bytes, the other side reads them in order; you read bytes, you receive them in the order they were written.

In Node.js, the `net` module exposes TCP primitives:

- **`net.createServer`** returns a server object that listens for incoming TCP connections.
- **`socket`** (a `net.Socket`) is the per-connection object passed to the connection handler. It emits events (`data`, `end`, `close`, `error`) and exposes methods (`write`, `end`).

Higher-level protocols like [[http-protocol-basics|HTTP]] are just an agreement about *what bytes mean* on top of this socket abstraction.

## Why it matters

Almost every web server you'll ever touch is built on TCP sockets. Going one layer below your framework — writing the bytes yourself — collapses a lot of mystery:

- "An HTTP request" is just bytes that arrive in a `data` event.
- "An HTTP response" is just bytes you pass to `socket.write()`.
- Persistent connections, keep-alive, head-of-line blocking — all become concrete when you can see the socket.

For a staff engineer, this is the layer where the interesting performance and reliability questions live (connection reuse, backpressure, TLS termination, head-of-line blocking).

## Mechanics

### Minimal Node TCP server

```ts
import * as net from "net";

const server = net.createServer((socket) => {
  socket.on("data", (data) => {
    // raw bytes arrive here — could be a Buffer or string
  });
  socket.on("close", () => {
    socket.end();
  });
});

server.listen(4221, "localhost");
```

### Key API surface

- **`net.createServer(listener)`** — creates a TCP (or IPC) server. The listener is called once per inbound connection with a fresh `socket`.
- **`socket.on("data", cb)`** — fires when bytes arrive. `data` is a `Buffer` by default (or a string if encoding is set).
- **`socket.write(chunk)`** — sends bytes to the peer. Returns `false` if the internal buffer is full (backpressure signal).
- **`socket.end([chunk])`** — sends any final bytes, then half-closes the local side.
- **`socket.on("close", cb)`** — fires when the connection is fully torn down.
- **`server.listen(port, host)`** — start accepting connections.

### Events on a server

- `close` on the *server* is **emitted only after all connections are ended**. Important: don't expect a fast shutdown if clients hold the socket open.

### Buffers vs strings

`data` events deliver a `Buffer` by default. Calling `.toString()` is fine for text protocols using ASCII headers, but:

- For arbitrary binary payloads, treat bytes as bytes — `.toString()` is lossy.
- For [[http-protocol-basics|HTTP]], `Content-Length` is in **bytes**, so use `Buffer.byteLength(body)` not `body.length`.

### TCP fragmentation: the trap

TCP is a *byte stream*, not a *message stream*. A single application-level message may arrive in multiple `data` events, or two messages may arrive in one. Anything beyond a toy server must buffer until a protocol-defined boundary (`\r\n\r\n`, length prefix, framing) is observed.

The toy HTTP server in [[project-byo-http-server-typescript]] sidesteps this by assuming a complete request fits in one `data` event — fine for `curl` on localhost, broken for the real world.

## Related

- [[http-protocol-basics]] — what HTTP looks like on top of a TCP socket.
- [[project-byo-http-server-typescript]] — using `net.createServer` to hand-roll an HTTP server.

## Sources

- [[project-byo-http-server-typescript]] (`raw/projects/Build your own HTTP Server in TypeScript.md`)
- Node.js docs: `net` module — https://nodejs.org/api/net.html
