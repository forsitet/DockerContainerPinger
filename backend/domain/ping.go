package domain

import "time"

type Ping struct {
	ID            uint   `gorm:"primaryKey"`
	IPAddress     string `gorm:"unique"`
	ContainerName string
	PingTime      float64
	LastSuccess   time.Time
}
