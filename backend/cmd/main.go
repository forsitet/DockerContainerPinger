package main

import (
	"flag"
	"log"
	"net/http"
	"github.com/go-chi/chi/v5"
	"internal/api/http/handlersUser"
)

func main() {
	// userRepo := repository.NewUserRepository(db)
	// userService := service.NewUserService(userRepo)
	// handler := http.NewHandler(userService)
	addr := flag.String("addr", ":8080", "address for http server")
	flag.Parse()
	r := chi.NewRouter()
	r.Post("/login", handlersUser.Login)

	log.Printf("Starting server on %s", *addr)
    if err := http.ListenAndServe(*addr, r); err != nil {
        log.Fatalf("Could not start server: %v", err)
    }
}