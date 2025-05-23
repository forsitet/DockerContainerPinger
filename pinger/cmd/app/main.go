package main

import (
	"log"
	"pinger/cmd/app/config"
	"pinger/domain"
	"pinger/internal/repository/kafka"
	"pinger/service"
	"sync"
	"time"

	dockerClient "github.com/docker/docker/client"

	"github.com/IBM/sarama"
)

func main() {
	appFlags := config.ParseFlags()
	var cfg config.AppConfig
	config.MustLoad(appFlags.ConfigPath, &cfg)
	cli, err := dockerClient.NewClientWithOpts(dockerClient.FromEnv, dockerClient.WithAPIVersionNegotiation())
	if err != nil {
		log.Fatalf("Ошибка создания клиента Docker: %s", err)
	}

	producer, err := sarama.NewSyncProducer([]string{cfg.Kafka.Broker}, nil)
	if err != nil {
		log.Fatalf("Ошибка создания продюсера Kafka: %s", err)
	}
	defer producer.Close()

	ticker := time.NewTicker(cfg.PingInterval)
	defer ticker.Stop()
	for range ticker.C {
		containerInfos, err := service.GetContainerInfo(cli)
		if err != nil {
			log.Printf("Ошибка получения контейнерной информации: %v", err)
			continue
		}
		var wg sync.WaitGroup
		resultsChan := make(chan *domain.PingResult, 100)
		for _, info := range containerInfos {
			if len(info.IPs) == 0 {
				continue
			}
			for _, ip := range info.IPs {
				wg.Add(1)
				go service.PingContainer(ip, info.ID, info.Name, &wg, resultsChan)
			}
		}
		go func() {
			wg.Wait()
			close(resultsChan)
		}()
		for result := range resultsChan {
			if err := kafka.PublishResult(producer, result); err != nil {
				log.Printf("Ошибка публикации результата для контейнера %s (%s): %v", result.ContainerID, result.IPAddress, err)
			} else {
				log.Printf("Опубликован результат пинга для контейнера %s (%s): %.2f мс", result.ContainerName, result.IPAddress, result.PingTime)
			}
		}
	}
}
