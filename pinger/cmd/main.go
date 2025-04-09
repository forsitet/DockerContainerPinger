package main

import (
    "log"
    // "os"
    // "time"
    "pinger/internal/docker"
    "pinger/internal/kafka"
    "pinger/internal/pinger"
    "pinger/config"
)

func main() {
    // Загрузка конфигурации
    cfg := config.Load()

    // Инициализация Docker-клиента
    dockerClient, err := docker.New()
    if err != nil {
        log.Fatalf("Ошибка инициализации Docker: %v", err)
    }

    // Инициализация продюсера Kafka
    kafkaProducer, err := kafka.New([]string{cfg.KafkaBroker})
    if err != nil {
        log.Fatalf("Ошибка инициализации Kafka: %v", err)
    }

    // Создание сервиса пинга
    pingService := ping.New(
        dockerClient,
        kafkaProducer,
        cfg.PingInterval,
    )

    // Запуск сервиса
    pingService.Run()
}