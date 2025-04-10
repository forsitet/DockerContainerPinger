package mocks

import (
	"back/domain"
	"time"
)

type InMemoryRepo struct {
	store map[uint]domain.Ping
}

func NewInMemoryRepo() *InMemoryRepo {
	return &InMemoryRepo{
		store: make(map[uint]domain.Ping),
	}
}

func (r *InMemoryRepo) Get(limit int) ([]domain.Ping, error) {
	result := make([]domain.Ping, 0, limit)
	count := 0

	for _, v := range r.store {
		result = append(result, v)
		count++
		if count >= limit {
			break
		}
	}

	return result, nil
}

func (r *InMemoryRepo) Post(value domain.Ping) error {
	r.store[value.ID] = value
	return nil
}

func (r *InMemoryRepo) Delete(t time.Time) error {
	for id, v := range r.store {
		if v.LastSuccess.Before(t) {
			delete(r.store, id)
		}
	}
	return nil
}
