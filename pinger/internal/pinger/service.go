package ping

import (
	"context"
	"log"
	"pinger/internal/docker"
	"pinger/internal/kafka"
	"pinger/domain"
	"sync"
	"time"

	ping "github.com/prometheus-community/pro-bing"
)

type Service struct {
    dockerClient  *docker.Client
    kafkaProducer *kafka.Producer
    interval      time.Duration
}

// New создает сервис пинга.
func New(dockerClient *docker.Client, kafkaProducer *kafka.Producer, interval time.Duration) *Service {
    return &Service{
        dockerClient:  dockerClient,
        kafkaProducer: kafkaProducer,
        interval:      interval,
    }
}

// Run запускает цикл пинга.
func (s *Service) Run() {
    ticker := time.NewTicker(s.interval)
    defer ticker.Stop()

    for range ticker.C {
        containers, err := s.dockerClient.GetContainers(context.Background())
        if err != nil {
            log.Printf("Ошибка получения контейнеров: %v", err)
            continue
        }

        var wg sync.WaitGroup
        results := make(chan *domain.Ping, 100)

        for _, container := range containers {
            for _, ip := range container.IPs {
                wg.Add(1)
                go s.ping(ip, container.ID, container.Name, &wg, results)
            }
        }

        go func() {
            wg.Wait()
            close(results)
        }()

        for result := range results {
            if err := s.kafkaProducer.Send("ping-results", result); err != nil {
                log.Printf("Ошибка отправки в Kafka: %v", err)
            }
        }
    }
}

func (s *Service) ping(ip, containerID, containerName string, wg *sync.WaitGroup, results chan<- *domain.Ping) {
    defer wg.Done()

    pinger, err := ping.NewPinger(ip)
    if err != nil {
        log.Printf("Ошибка создания пингера: %v", err)
        return
    }

    pinger.Count = 3
    pinger.Timeout = 5 * time.Second
    pinger.SetPrivileged(true)

    if err := pinger.Run(); err != nil {
        log.Printf("Ошибка пинга: %v", err)
        return
    }

    stats := pinger.Statistics()
    results <- &domain.Ping{
        ContainerID:   containerID,
        ContainerName: containerName,
        IPAddress:     ip,
        PingTime:      float64(stats.AvgRtt) / float64(time.Millisecond),
        LastSuccess:   time.Now(),
    }
}