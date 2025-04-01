package main

import (
	_ "back/docs"
	"back/internal/repository/postgres"
	"flag"
	"log"
	"net/http"

	httpSwagger "github.com/swaggo/http-swagger"

	"github.com/go-chi/chi/v5"
)

// @title Task API
// @version 1.0
// @host localhost:8080
// @BasePath /
func main() {
	db := postgres.InitDB()
	_ = db
	addr := flag.String("addr", ":8080", "address for http server")
	flag.Parse()
	r := chi.NewRouter()
	r.Get("/swagger/*", httpSwagger.WrapHandler)
	log.Printf("Starting server on %s", *addr)
	if err := http.ListenAndServe(*addr, r); err != nil {
		log.Fatalf("Could not start server: %v", err)
	}
}
