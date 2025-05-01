package ping

import (
	"pinger/domain/repository"
	"time"

	probing "github.com/prometheus-community/pro-bing"
)

// PingerInterface определяем интерфейс для pinger
type PingerInterface interface {
	Run() error
	OnFinish(func(*probing.Statistics))
}

// pingerWrapper обертка для *probing.Pinger, которая реализует PingerInterface
type pingerWrapper struct {
	*probing.Pinger
	doneFunc func(*probing.Statistics)
	stats    *probing.Statistics
}

func (pw *pingerWrapper) OnFinish(f func(*probing.Statistics)) {
	pw.doneFunc = f
	pw.Pinger.OnRecv = func(pkt *probing.Packet) {
		// Здесь можно обновлять статистику по мере получения пакетов
	}
	pw.Pinger.OnFinish = func(stats *probing.Statistics) {
		if pw.doneFunc != nil {
			pw.doneFunc(stats)
		}
	}
}

type Service struct {
	dockerRepo repository.DockerRepository
	pingRepo   repository.PingRepository
	interval   time.Duration
	newPinger  func(ip string) (PingerInterface, error)
}

func NewService(
	dockerRepo repository.DockerRepository,
	pingRepo repository.PingRepository,
	interval time.Duration,
) *Service {
	return &Service{
		dockerRepo: dockerRepo,
		pingRepo:   pingRepo,
		interval:   interval,
		newPinger: func(ip string) (PingerInterface, error) {
			pinger, err := probing.NewPinger(ip)
			if err != nil {
				return nil, err
			}
			pinger.SetPrivileged(true)
			pinger.Count = 3
			pinger.Timeout = 5 * time.Second
			return &pingerWrapper{Pinger: pinger}, nil
		},
	}
}