package ping

import (
	"log"
	"sync"
	"time"

	"github.com/prometheus-community/pro-bing"
	"pinger/domain"
	"pinger/internal/docker"
	"pinger/internal/kafka"
)

type Service struct {
	dockerClient  *docker.Client
	kafkaProducer *kafka.Producer
	interval      time.Duration
}

func New(dockerClient *docker.Client, kafkaProducer *kafka.Producer, interval time.Duration) *Service {
	return &Service{
		dockerClient:  dockerClient,
		kafkaProducer: kafkaProducer,
		interval:      interval,
	}
}

func (s *Service) Run() {
	ticker := time.NewTicker(s.interval)
	defer ticker.Stop()

	for range ticker.C {
		s.pingAllContainers()
	}
}

func (s *Service) pingAllContainers() {
	containerInfos, err := s.dockerClient.GetContainerInfos()
	if err != nil {
		log.Printf("Ошибка получения информации о контейнерах: %v", err)
		return
	}

	var wg sync.WaitGroup
	resultsChan := make(chan *domain.PingResult, 100)

	for _, info := range containerInfos {
		if len(info.IPs) == 0 {
			continue
		}

		for _, ip := range info.IPs {
			wg.Add(1)
			go s.pingContainer(ip, info.ID, info.Name, &wg, resultsChan)
		}
	}

	go func() {
		wg.Wait()
		close(resultsChan)
	}()

	for result := range resultsChan {
		if err := s.kafkaProducer.Publish(result); err != nil {
			log.Printf("Ошибка публикации результата: %v", err)
		} else {
			log.Printf("Успешно опубликован результат пинга для %s", result.ContainerName)
		}
	}
}

func (s *Service) pingContainer(ip, containerID, containerName string, wg *sync.WaitGroup, results chan<- *domain.PingResult) {
	defer wg.Done()

	pinger, err := probing.NewPinger(ip)
	if err != nil {
		log.Printf("Ошибка создания пингера для %s: %v", ip, err)
		return
	}

	pinger.SetPrivileged(true)
	pinger.Count = 3
	pinger.Timeout = 5 * time.Second

	if err := pinger.Run(); err != nil {
		log.Printf("Ошибка пинга %s: %v", ip, err)
		return
	}

	stats := pinger.Statistics()
	pingTime := float64(stats.AvgRtt) / float64(time.Millisecond)

	results <- &domain.PingResult{
		ContainerID:   containerID,
		ContainerName: containerName,
		IPAddress:     ip,
		PingTime:      pingTime,
		LastSuccess:   time.Now(),
	}
}