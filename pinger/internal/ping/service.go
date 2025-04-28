package ping

import (
	"pinger/domain/repository"
	"time"
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