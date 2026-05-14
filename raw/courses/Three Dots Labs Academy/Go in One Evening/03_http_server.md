---
creation date: 2026-04-19 12:11
modification date: Sunday 19th April 2026 12:11:09
tags:
  - chapter
status:
  - in-progress
---
- Go comes with an in-built production ready [[HTTP]] library.
- To start an [[HTTP]] server, run the following in your `main` function.

```go
package main

import (
	"net/http"
	"log"
	"fmt"
)

func main() {
	// controller for the /api/v1/user endpoint
	http.HandleFunc("/api/v1/user", handlerFunction)
	// starts the http server on http://localhost:8080
	log.Fatal(http.ListenAndServe(":8080", nil))
}

func handlerFunction(w http.ResponseWriter, r *http.Request) {
	// receive the name from the query parameter: /api/v1/user?name="Shivayan"
	name := r.URL.Query().Get("name")
	// formats using the default formats for its operands and writes to w. Spaces are added between operands when neither is a string. It returns the number of bytes written and any write error encountered.
	fmt.Fprint(w, "Hello, my name is ", name)
}
```

- By default the [[HTTP]] handler returns `200 OK` status when any content is written to `http.ResponseWriter`.
- We can write custom status codes using `w.WriteHeader` and we need to do it before writing any content, otherwise it won't have any effect.
	- `w.WriteHeader` doesn't interrupt the execution of the handler function and if we need to finish an [[HTTP]] request early, we need to explicitly use `return`.

```go
package main

import (
	"fmt"
	"log"
	"net/http"
)

func main() {
	http.HandleFunc("/hello", controllerFunc)
	log.Fatal(http.ListenAndServe(":8080", nil))
}

func controllerFunc(w http.ResponseWriter, r *http.Request) {
	name := r.URL.Query().Get("name")
	
	// if the name is blank in the query parameters, send a bad request status code back to the client.
	if name == "" {
		w.WriteHeader(http.StatusBadRequest)
		return
	}
	fmt.Fprint(w, "Hello, ", name)
}
```
