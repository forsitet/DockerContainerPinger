package main

import (
	"context"
	"log"
	"os"
	"os/signal"
	"syscall"

	"pinger/cmd/app/config"
	"pinger/internal/ping"
	"pinger/internal/repository/kafka"
	"pinger/service/docker"
)

func main() {
	cfg := config.Load()

	ctx, cancel := context.WithCancel(context.Background())
	defer cancel()

	go func() {
		sigChan := make(chan os.Signal, 1)
		signal.Notify(sigChan, syscall.SIGINT, syscall.SIGTERM)
		<-sigChan
		cancel()
	}()

	dockerRepo, err := docker.New()
	if err != nil {
		log.Fatalf("Docker initialization error: %v", err)
	}

	kafkaRepo, err := kafka.New([]string{cfg.GetKafkaBroker()})
	if err != nil {
		log.Fatalf("Kafka initialization error: %v", err)
	}

	pingService := ping.NewService(
		dockerRepo,
		kafkaRepo,
		cfg.GetPingInterval(),
	)

	pingService.Run(ctx)
	log.Println("Service stopped gracefully")
}