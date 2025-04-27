package main

import (
	"log"
	
	"pinger/config"
	"pinger/internal/docker"
	"pinger/internal/kafka"
	"pinger/internal/ping"
)

func main() {
	cfg := config.Load()

	dockerClient, err := docker.New()
	if err != nil {
		log.Fatalf("Ошибка инициализации Docker: %v", err)
	}

	kafkaProducer, err := kafka.New([]string{cfg.KafkaBroker})
	if err != nil {
		log.Fatalf("Ошибка инициализации Kafka: %v", err)
	}

	pingService := ping.New(
		dockerClient,
		kafkaProducer,
		cfg.PingInterval,
	)
	
	pingService.Run()
}