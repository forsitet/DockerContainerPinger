package main

import (
	"database/sql"
	"fmt"

	// _ "back/docs"
	"back/cmd/app/config"
	handler "back/internal/api/http"
	"back/internal/repository/kafka"
	"back/internal/repository/postgres"
	"back/usecases/service"
	"log"
	"net/http"

	_ "github.com/lib/pq"
	httpSwagger "github.com/swaggo/http-swagger"

	"github.com/go-chi/chi/v5"
)

// @title My API
// @version 1.0
// @description This is a Docker-container service

// @host localhost:8080
// @BasePath /
func main() {
	appFlags := config.ParseFlags()
	var cfg config.AppConfig
	config.MustLoad(appFlags.ConfigPath, &cfg)
	dbName := "ping"

	defaultDBConnStr := fmt.Sprintf("host=%s port=%s user=%s password=%s dbname=postgres sslmode=disable",
		cfg.BD.Host, cfg.BD.Port, cfg.BD.User, cfg.BD.Password)

	postgresdb, err := sql.Open("postgres", defaultDBConnStr)
	if err != nil {
		log.Fatalf("connection error to %s: %s", dbName, err)
	}
	postgres.CreatePingRepository(dbName, postgresdb)

	pingDBConnStr := fmt.Sprintf("host=%s port=%s user=%s password=%s dbname=%s sslmode=disable",
		cfg.BD.Host, cfg.BD.Port, cfg.BD.User, cfg.BD.Password, dbName)
	pingDB, err := sql.Open("postgres", pingDBConnStr)
	if err != nil {
		log.Fatalf("connection error to %s: %s", dbName, err)
	}
	postgres.InitPingTables(pingDB)

	pingRepo := postgres.NewPingRepository(pingDB)
	pingService := service.NewServicePing(pingRepo)
	pingHandler := handler.NewHandlerPing(pingService)

	go kafka.NewKafkaConsumer(cfg.Kafka.Broker, "backend-group", []string{"ping"}, &kafka.Consumer{
		Repo: pingRepo,
	})

	r := chi.NewRouter()
	r.Get("/swagger/*", httpSwagger.WrapHandler)
	r.Get("/api/pings", pingHandler.GetPing)
	r.Post("/api/ping", pingHandler.PostPing)
	r.Delete("/api/pings/old", pingHandler.DeleteOldPing)

	log.Printf("Starting server on %s", cfg.HTTP.Address)
	if err := http.ListenAndServe(cfg.HTTP.Address, r); err != nil {
		log.Fatalf("Could not start server: %v", err)
	}
}
