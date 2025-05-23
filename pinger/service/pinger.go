package service

import (
	"context"
	"log"
	"pinger/domain"
	"strings"
	"sync"
	"time"

	"github.com/docker/docker/api/types"
	ping "github.com/prometheus-community/pro-bing"
)

type ContainerLister interface {
	ContainerList(ctx context.Context, options types.ContainerListOptions) ([]types.Container, error)
}

func GetContainerInfo(cli ContainerLister) (map[string]domain.ContainerInfo, error) {
	containers, err := cli.ContainerList(context.Background(), types.ContainerListOptions{})
	if err != nil {
		return nil, err
	}

	results := make(map[string]domain.ContainerInfo)
	for _, container := range containers {
		var name string
		if len(container.Names) > 0 {
			name = strings.TrimPrefix(container.Names[0], "/")
		} else {
			name = container.ID[:12]
		}

		var ips []string
		for _, netSettings := range container.NetworkSettings.Networks {
			if netSettings.IPAddress != "" {
				ips = append(ips, netSettings.IPAddress)
			}
		}

		results[container.ID] = domain.ContainerInfo{
			ID:   container.ID,
			Name: name,
			IPs:  ips,
		}
	}
	return results, nil
}

func PingContainer(ip, containerID, containerName string, wg *sync.WaitGroup, results chan<- *domain.PingResult) {
	defer wg.Done()
	pinger, err := ping.NewPinger(ip)
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
