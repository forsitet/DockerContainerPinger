package config

import (
	"os"
	"time"
)

// Config содержит конфигурацию приложения
type Config struct {
	KafkaBroker  string
	PingInterval time.Duration
}

// Load загружает конфигурацию из переменных окружения
func Load() *Config {
	return &Config{
		KafkaBroker:  getEnv("KAFKA_BROKER", "kafka:9092"),
		PingInterval: parseDuration(getEnv("PING_INTERVAL", "10s")),
	}
}

func getEnv(key, defaultValue string) string {
	if value, exists := os.LookupEnv(key); exists {
		return value
	}
	return defaultValue
}

func parseDuration(value string) time.Duration {
	duration, err := time.ParseDuration(value)
	if err != nil {
		return 10 * time.Second
	}
	return duration
}