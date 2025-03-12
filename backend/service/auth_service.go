package service

import (
    "errors"
    "backend/internal/repository"
    "backend/domain"
)

var (
    ErrInvalidCredentials = errors.New("invalid credentials")
)

func Authenticate(username, password string) (*domain.User, string, error) {
    user, err := repository.GetUserByUsername(username)
    if err != nil {
        return nil, "", ErrInvalidCredentials
    }

    if user.Password != password {
        return nil, "", ErrInvalidCredentials
    }

    token := "generated-token" 

    return user, token, nil
}