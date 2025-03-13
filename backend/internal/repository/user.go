package repository

import (
    "backend/domain"
    "backend/errors"
    "sync"
)

type InMemoryDB struct {
    users map[string]*domain.User
    mu    sync.RWMutex
}

func NewInMemoryDB() *InMemoryDB {
    return &InMemoryDB{
        users: make(map[string]*domain.User),
    }
}

type UserRepository struct {
    db *InMemoryDB
}

func NewUserRepository(db *InMemoryDB) *UserRepository {
    return &UserRepository{db: db}
}

func (r *UserRepository) GetUserByUsername(username string) (*domain.User, error) {
    r.db.mu.RLock()
    defer r.db.mu.RUnlock()

    user, exists := r.db.users[username]
    if !exists {
        return nil, errors.ErrUserNotFound
    }

    return user, nil
}

func (r *UserRepository) AddUser(user *domain.User) error {
    r.db.mu.Lock()
    defer r.db.mu.Unlock()

    if _, exists := r.db.users[user.Username]; exists {
        return errors.ErrUserAlreadyExists
    }

    r.db.users[user.Username] = user
    return nil
}