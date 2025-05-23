package domain

import "time"

type PingResult struct {
	ContainerID   string    `json:"container_id"`
	ContainerName string    `json:"container_name"`
	IPAddress     string    `json:"ip_address"`
	PingTime      float64   `json:"ping_time"`
	LastSuccess   time.Time `json:"last_success"`
}
