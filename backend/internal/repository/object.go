package repository

import (
	"back/domain"
	"time"
)

type Object interface {
	Get(limit int) ([]domain.Ping, error)
	Post(pr domain.Ping) error 
	Delete(before time.Time) error
}
