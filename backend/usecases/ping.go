package usecases

import (
	"back/domain"
	"time"
)

type Ping interface {
	GetPingResults(limit int) ([]domain.Ping, error)
	InsertPingResult(value domain.Ping) error
	DeleteOldPingResult(time time.Time) error
}
