package main

import (
	"flag"
	"log"
	"net/http"

	"github.com/go-chi/chi/v5"
)

func main() {

	addr := flag.String("addr", ":8080", "address for http server")
	flag.Parse()

	r := chi.NewRouter()
	r.Post("/login", handler.Login)

	log.Printf("Starting server on %s", *addr)
	if err := http.ListenAndServe(*addr, r); err != nil {
		log.Fatalf("Could not start server: %v", err)
	}
}
