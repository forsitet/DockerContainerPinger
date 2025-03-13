package main

import (
	handlersUser "backend/internal/api/http"
	"backend/internal/repository"
	"backend/service"
	"flag"
	"log"
	"net/http"

	"github.com/go-chi/chi/v5"
)

func main() {
	db := repository.NewInMemoryDB()
	userRepo := repository.NewUserRepository(db)

	hashedPassword, err := service.HashPassword("test")
	if err != nil {
		log.Fatalf("Failed to hash password: %v", err)
	}

	authService := service.NewAuthService(userRepo)
	handler := handlersUser.NewHandler(authService)

	addr := flag.String("addr", ":8080", "address for http server")
	flag.Parse()

	r := chi.NewRouter()
	r.Post("/login", handler.Login)

	log.Printf("Starting server on %s", *addr)
	if err := http.ListenAndServe(*addr, r); err != nil {
		log.Fatalf("Could not start server: %v", err)
	}
}
