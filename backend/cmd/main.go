package main

import (
	"net/http"
	"github.com/go-chi/chi/v5"
	"internal/api/http/handlersUser"
)

func main() {
	// userRepo := repository.NewUserRepository(db)
	// userService := service.NewUserService(userRepo)
	// handler := http.NewHandler(userService)

	// Роутер
	r := chi.NewRouter()
	r.Post("/login", handlersUser.Login)

	http.ListenAndServe(":8080", r)
}