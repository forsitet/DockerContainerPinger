package config

import (
	"flag"
	"log"
	"os"
	"time"

	"github.com/ilyakaznacheev/cleanenv"
)

type AppFlags struct {
	ConfigPath string
}

type KafkaConfig struct {
	Broker string `yaml:"broker"`
}

type AppConfig struct {
	Kafka        KafkaConfig `yaml:"kafka"`
	PingInterval time.Duration   `yaml:"pingInterval"`
}

func ParseFlags() AppFlags {
	configPath := flag.String("config", "", "Path to config")
	flag.Parse()
	return AppFlags{
		ConfigPath: *configPath,
	}
}

func MustLoad(cfgPath string, cfg any) {
	if cfgPath == "" {
		log.Fatal("Config path is not set")
	}

	if _, err := os.Stat(cfgPath); os.IsNotExist(err) {
		log.Fatalf("config file does not exist by this path %s", cfgPath)
	}

	if err := cleanenv.ReadConfig(cfgPath, cfg); err != nil {
		log.Fatalf("error reading config: %s", err)
	}
}
