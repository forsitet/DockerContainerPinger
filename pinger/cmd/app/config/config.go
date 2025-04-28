package config

import (
	"os"
	"time"
	"gopkg.in/yaml.v3"
	"io/ioutil"
)

type Config struct {
	Kafka struct {
		Broker string `yaml:"broker"`
	} `yaml:"kafka"`
	Ping struct {
		Interval string `yaml:"interval"`
	} `yaml:"ping"`
}

func Load() *Config {
	cfg := &Config{}
	
	data, err := ioutil.ReadFile("config.yaml")
	if err != nil {
		panic(err)
	}

	err = yaml.Unmarshal(data, cfg)
	if err != nil {
		panic(err)
	}

	return cfg
}

func (c *Config) GetKafkaBroker() string {
	if broker := os.Getenv("KAFKA_BROKER"); broker != "" {
		return broker
	}
	return c.Kafka.Broker
}

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