---
creation date: 2026-04-25 10:56
modification date: Saturday 25th April 2026 10:56:59
tags:
  - project
  - typescript
  - http
repository:
status:
  - in-progress
---

## References

- Source: https://app.codecrafters.io/courses/http-server/overview?track=typescript
- HTTP MDN Documentation: https://developer.mozilla.org/en-US/docs/Web/HTTP

## Stack

- [[TypeScript]]
- [[Node.js]]

## Introduction

### Local Setup

- Clone repository

```bash
git clone https://git.codecrafters.io/e30131636f0508e4 codecrafters-http-server-typescript
cd codecrafters-http-server-typescript
```

- Test CLI connection

```bash
curl -fsSL https://codecrafters.io/install.sh | bash 
codecrafters ping
```

### Bind to a Port

- [[HTTP]] servers communication over [[TCP]], the protocol that powers most web traffic.
- We would be implementing a [[TCP]] server that listens on port `4221`, just like a real [[HTTP]] server.

```ts
import * as net from "net";

const server = net.createServer((socket) => {
  socket.on("close", () => {
    socket.end();
  });
});

server.listen(4221, "localhost");
```

- `net.CreateServer`: Creates a new [[TCP]] or [[IPC]] Server.
	- `socket`: Abstraction of a [[TCP]] socket or a streaming [[IPC]] endpoint.
		- Can be used directly to interact with a server.
		- `close` is an event which is emitted when the server closes.
			- If connections exist, the event is not emitted until all connections are ended.
- `server.listen()`: Start a server listening for connections.
	- `server.listen(4221, "localhost")`: Start a server listening to port `4221` on `localhost`.

### Respond with 200

- An HTTP response is made up of three parts, each separated by a [CRLF](https://developer.mozilla.org/en-US/docs/Glossary/CRLF) (`\r\n`):
	- Status line
	- Zero or more headers, each ending with a CLRF
	- Optional response body
- Expected response: `HTTP/1.1 200 OK\r\n\r\n`

```javascript
// Status line
HTTP/1.1  // HTTP version
200       // Status code
OK        // Optional reason phrase
\r\n      // CRLF that marks the end of the status line

// Headers (empty)
\r\n      // CRLF that marks the end of the headers

// Response body (empty)
```

```typescript
socket.write("HTTP/1.1 200 OK\r\n\r\n");
```

- `socket.write()`: Sends data on the socket.

### Extract URL Path

- We would be extracting the [[URL]] from the HTTP request.
- An HTTP request is made up of three parts, each separated by a [CRLF](https://developer.mozilla.org/en-US/docs/Glossary/CRLF) (`\r\n`):
	- Request line.
	- Zero or more headers, each ending with a CRLF.
	- Optional request body.
- Here's an example of an HTTP request:

```javascript
GET /index.html HTTP/1.1\r\nHost: localhost:4221\r\nUser-Agent: curl/7.64.1\r\nAccept: */*\r\n\r\n
```

- Breakdown of the request:

```javascript
// Request line
GET                          // HTTP method
/index.html                  // Request target
HTTP/1.1                     // HTTP version
\r\n                         // CRLF that marks the end of the request line

// Headers
Host: localhost:4221\r\n     // Header that specifies the server's host and port
User-Agent: curl/7.64.1\r\n  // Header that describes the client's user agent
Accept: */*\r\n              // Header that specifies which media types the client can accept
\r\n                         // CRLF that marks the end of the headers

// Request body (empty)
```

```typescript
// listening to even associated with when data is received (request)
socket.on("data", (data) => {
	// Capture URL and check if the path is `/`
    if (data.toString().trim().split(" ")[1] === "/") {
      socket.write("HTTP/1.1 200 OK\r\n\r\n"); // success response
    } else {
      socket.write("HTTP/1.1 404 Not Found\r\n\r\n"); // error response
    }
});
```

- `data` can be a `Buffer` or `String`.

### Respond with a Body

- A response body is used to return content to the client.
	- This content can be an entire web page, a file, a string, or anything else that can be represented with bytes.
- The `/echo/{str}` endpoint must return a `200` response, with the response body set to given string, and with a `Content-Type` and `Content-Length` header.
- Request:

```javascript
GET /echo/abc HTTP/1.1\r\nHost: localhost:4221\r\nUser-Agent: curl/7.64.1\r\nAccept: */*\r\n\r\n
```

- Response:

```javascript
HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\nContent-Length: 3\r\n\r\nabc
```

- Breakdown of the response:

```javascript
// Status line
HTTP/1.1 200 OK
\r\n // CRLF that marks the end of the status line

// Headers
Content-Type: text/plain\r\n // Header that specifies the format of the response body
Content-Length: 3\r\n // Header that specifies the size of the response body, in bytes
\r\n // CRLF that marks the end of the headers

// Response body
abc // The string from the request
```

```typescript
  socket.on("data", (data) => {
    const path = data.toString().trim().split(" ")[1];

    if (path === "/") {
      socket.write("HTTP/1.1 200 OK\r\n\r\n");
    } else if (path.startsWith("/echo")) {
      const parameter = path.split("/")[2] || "";
      socket.write(
        `HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\nContent-Length: ${parameter.length}\r\n\r\n${parameter}\r\n`,
      );
    } else {
      socket.write("HTTP/1.1 404 Not Found\r\n\r\n");
    }
  });
```

### Read Header

- 
