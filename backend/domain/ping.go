package domain

import "time"

type Ping struct {
	ID            uint      `json:"id,omitempty"`
	IPAddress     string    `json:"ip_address"`
	ContainerName string    `json:"container_name"`
	PingTime      float64   `json:"ping_time"`
	LastSuccess   time.Time `json:"last_success"`
}

type ContainerInfo struct {
    ID   string
    Name string
    IPs  []string
}