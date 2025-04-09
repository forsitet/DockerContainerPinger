package config

import (
	"log"
	"os"
	"time"
)

type Config struct {
    KafkaBroker   string
    PingInterval  time.Duration
}

func Load() *Config {
    pingIntervalStr := os.Getenv("PING_INTERVAL")
    pingInterval, err := time.ParseDuration(pingIntervalStr)
    if err != nil {
        log.Fatalf("Ошибка парсинга PING_INTERVAL: %v", err)
    }
    
    return &Config{
        KafkaBroker:  os.Getenv("KAFKA_BROKER"),
        PingInterval: pingInterval,
    }
}