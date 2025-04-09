package main

import (
	// "back/domain"
	"context"
	"encoding/json"
	"log"
	"os"
	"strings"
	"sync"
	"time"

	"github.com/IBM/sarama"
	"github.com/docker/docker/api/types"
	dockerClient "github.com/docker/docker/client"
	"github.com/go-ping/ping"
)

type Ping struct {
	ContainerID   string    `json:"container_id"`
	ContainerName string    `json:"container_name"`
	IPAddress     string    `json:"ip_address"`
	PingTime      float64   `json:"ping_time"`
	LastSuccess   time.Time `json:"last_success"`
}

type ContainerInfo struct {
	ID   string
	Name string
	IPs  []string
}

func getContainerInfos(cli *dockerClient.Client) (map[string]ContainerInfo, error) {
	containers, err := cli.ContainerList(context.Background(), types.ContainerListOptions{})
	if err != nil {
		return nil, err
	}
	
	results := make(map[string]ContainerInfo)
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
		
		results[container.ID] = ContainerInfo{
			ID:   container.ID,
			Name: name,
			IPs:  ips,
		}
	}
	return results, nil
}

func pingContainer(ip, containerID, containerName string, wg *sync.WaitGroup, results chan<- *Ping) {
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
	results <- &Ping{
		ContainerID:   containerID,
		ContainerName: containerName,
		IPAddress:     ip,
		PingTime:      pingTime,
		LastSuccess:   time.Now(),
	}
}

func publishResult(producer sarama.SyncProducer, result *Ping) error {
	data, err := json.Marshal(result)
	if err != nil {
		return err
	}
	
	msg := &sarama.ProducerMessage{
		Topic: "ping-results",
		Value: sarama.ByteEncoder(data),
	}
	
	_, _, err = producer.SendMessage(msg)
	return err
}

func main() {
	cli, err := dockerClient.NewClientWithOpts(dockerClient.FromEnv, dockerClient.WithAPIVersionNegotiation())
	if err != nil {
		log.Fatalf("Ошибка создания клиента Docker: %s", err)
	}
	
	kafkaBroker := os.Getenv("KAFKA_BROKER")
	if kafkaBroker == "" {
		kafkaBroker = "kafka:9092"
	}
	
	producer, err := sarama.NewSyncProducer([]string{kafkaBroker}, nil)
	if err != nil {
		log.Fatalf("Ошибка создания продюсера Kafka: %s", err)
	}
	defer producer.Close()
	
	pingIntervalStr := os.Getenv("PING_INTERVAL")
	if pingIntervalStr == "" {
		pingIntervalStr = "10s"
	}
	pingInterval, err := time.ParseDuration(pingIntervalStr)
	if err != nil {
		log.Printf("Неверный формат PING_INTERVAL, используется значение по умолчанию: 10s. Ошибка: %v", err)
		pingInterval = 10 * time.Second
	}
	
	ticker := time.NewTicker(pingInterval)
	defer ticker.Stop()
	for range ticker.C {
		containerInfos, err := getContainerInfos(cli)
		if err != nil {
			log.Printf("Ошибка получения контейнерной информации: %v", err)
			continue
		}
		var wg sync.WaitGroup
		resultsChan := make(chan *Ping, 100)
		for _, info := range containerInfos {
			if len(info.IPs) == 0 {
				continue
			}
			for _, ip := range info.IPs {
				wg.Add(1)
				go pingContainer(ip, info.ID, info.Name, &wg, resultsChan)
			}
		}
		go func() {
			wg.Wait()
			close(resultsChan)
		}()
		for result := range resultsChan {
			if err := publishResult(producer, result); err != nil {
				log.Printf("Ошибка публикации результата для контейнера %s (%s): %v", result.ContainerID, result.IPAddress, err)
			} else {
				log.Printf("Опубликован результат пинга для контейнера %s (%s): %.2f мс", result.ContainerName, result.IPAddress, result.PingTime)
			}
		}
	}
}