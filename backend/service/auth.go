package service

import (
    "golang.org/x/crypto/bcrypt"
    "backend/internal/repository"
    "backend/domain"
    "backend/service/errors"
)

func HashPassword(password string) (string, error) {
    hashedPassword, err := bcrypt.GenerateFromPassword([]byte(password), bcrypt.DefaultCost)
    if err != nil {
        return "", err
    }
    return string(hashedPassword), nil
}

func CheckPasswordHash(password, hash string) bool {
    err := bcrypt.CompareHashAndPassword([]byte(hash), []byte(password))
    return err == nil
}

func Authenticate(username, password string) (*domain.User, string, error) {
    user, err := repository.GetUserByUsername(username)
    if err != nil {
        return nil,  errors.ErrInvalidCredentials
    }

    if CheckPasswordHash(password, user.Password) {
        return nil, errors.ErrInvalidCredentials
    }


    return user, nil
}