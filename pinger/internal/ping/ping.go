package ping

import (
	"context"
	"log"
	"sync"
	"time"

	probing "github.com/prometheus-community/pro-bing"
	"pinger/domain/model"
	"pinger/domain/repository"
)

type Service struct {
	dockerRepo repository.DockerRepository
	pingRepo   repository.PingRepository
	interval   time.Duration
}

func New(
	dockerRepo repository.DockerRepository,
	pingRepo repository.PingRepository,
	interval time.Duration,
) *Service {
	return &Service{
		dockerRepo: dockerRepo,
		pingRepo:   pingRepo,
		interval:   interval,
	}
}

func (s *Service) Run(ctx context.Context) {
	ticker := time.NewTicker(s.interval)
	defer ticker.Stop()

	for {
		select {
		case <-ctx.Done():
			return
		case <-ticker.C:
			s.pingContainers(ctx)
		}
	}
}

func (s *Service) pingContainers(ctx context.Context) {
	containers, err := s.dockerRepo.GetContainerInfos(ctx)
	if err != nil {
		log.Printf("Error getting containers: %v", err)
		return
	}

	var wg sync.WaitGroup
	results := make(chan *model.PingResult, len(containers))

	for _, container := range containers {
		for _, ip := range container.IPs {
			wg.Add(1)
			go s.pingContainer(ctx, &wg, results, container.ID, container.Name, ip)
		}
	}

	go func() {
		wg.Wait()
		close(results)
	}()

	for result := range results {
		if err := s.pingRepo.Publish(ctx, result); err != nil {
			log.Printf("Error publishing ping result: %v", err)
		}
	}
}

func (s *Service) pingContainer(
	ctx context.Context,
	wg *sync.WaitGroup,
	results chan<- *model.PingResult,
	containerID string,
	containerName string,
	ip string,
) {
	defer wg.Done()

	pinger, err := probing.NewPinger(ip)
	if err != nil {
		log.Printf("Error creating pinger for %s: %v", ip, err)
		return
	}

	pinger.SetPrivileged(true)
	pinger.Count = 3
	pinger.Timeout = 5 * time.Second
	pinger.OnFinish = func(stats *probing.Statistics) {
		pingTime := float64(stats.AvgRtt) / float64(time.Millisecond)

		select {
		case <-ctx.Done():
			return
		case results <- &model.PingResult{
			ContainerID:   containerID,
			ContainerName: containerName,
			IPAddress:     ip,
			PingTime:      pingTime,
			LastSuccess:   time.Now(),
		}:
		}
	}

	if err := pinger.Run(); err != nil {
		log.Printf("Ping error for %s: %v", ip, err)
		return
	}
}