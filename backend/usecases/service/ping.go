package service

import (
	"back/domain"
	"back/internal/repository"
	"log"
	"time"
)

type pingRepo struct {
	repo repository.Object
}

func NewServicePing(repo repository.Object) *pingRepo {
	return &pingRepo{repo: repo}
}

func (rs *pingRepo) GetPingResults(limit int) ([]domain.Ping, error) {
	const op = "service.GetPingResults"
	result, err := rs.repo.Get(limit)
	if err != nil {
		log.Println(op, err)
	}
	return result, err
}

func (rs *pingRepo) InsertPingResult(value domain.Ping) error {
	const op = "service.InsertPingResult"
	err := rs.repo.Post(value)
	if err != nil {
		log.Println(op, err)
	}
	return err
}

func (rs *pingRepo) DeleteOldPingResult(time time.Time) error {
	const op = "service.DeleteOldPingResult"
	err := rs.repo.Delete(time)
	if err != nil {
		log.Println(op, err)
	}
	return err
}

