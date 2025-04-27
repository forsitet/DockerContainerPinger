package config

import (
	"os"
	"time"
	"gopkg.in/yaml.v3"
	"io/ioutil"
)

// Config содержит конфигурацию приложения
type Config struct {
	Kafka struct {
		Broker string `yaml:"broker"`
	} `yaml:"kafka"`
	Ping struct {
		Interval string `yaml:"interval"`
	} `yaml:"ping"`
}

// Load загружает конфигурацию из YAML файла
func Load() *Config {
	cfg := &Config{}
	
	// Чтение файла конфигурации
	data, err := ioutil.ReadFile("config.yaml")
	if err != nil {
		panic(err)
	}

	// Парсинг YAML
	err = yaml.Unmarshal(data, cfg)
	if err != nil {
		panic(err)
	}

	return cfg
}

// GetKafkaBroker возвращает адрес брокера Kafka
func (c *Config) GetKafkaBroker() string {
	if broker := os.Getenv("KAFKA_BROKER"); broker != "" {
		return broker
	}
	return c.Kafka.Broker
}

// GetPingInterval возвращает интервал ping-запросов
func (c *Config) GetPingInterval() time.Duration {
	if interval := os.Getenv("PING_INTERVAL"); interval != "" {
		duration, err := time.ParseDuration(interval)
		if err == nil {
			return duration
		}
	}
	
	duration, err := time.ParseDuration(c.Ping.Interval)
	if err != nil {
		return 10 * time.Second
	}
	return duration
}