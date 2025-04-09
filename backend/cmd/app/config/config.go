package config

import (
	"flag"
	"log"
	"os"

	"github.com/ilyakaznacheev/cleanenv"
)

type AppFlags struct {
	ConfigPath string
}

type BDConfig struct {
	Host     string `yaml:"host"`
	User     string `yaml:"user"`
	Password string `yaml:"password"`
	Port     string `yaml:"port"`
}

type HTTPConfig struct {
	Address string `yaml:"address"`
}

type KafkaConfig struct {
	Broker string `yaml:"broker"`
}

type Redis struct {
	Port uint16 `yaml:"port"`
}

type AppConfig struct {
	BD    BDConfig    `yaml:"bd"`
	HTTP  HTTPConfig  `yaml:"http"`
	Kafka KafkaConfig `yaml:"kafka"`
	Redis Redis       `yaml:"redis"`
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
