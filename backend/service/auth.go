package service

import (
	"backend/domain"

	"golang.org/x/crypto/bcrypt"
)

type AuthService struct {
	userRepo UserRepository
}

func NewAuthService(userRepo UserRepository) *AuthService {
	return &AuthService{userRepo: userRepo}
}

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

func (s *AuthService) Authenticate(username, password string) (*domain.User, error) {
	user, err := s.userRepo.GetUserByUsername(username)
	if err != nil {
		return nil, ErrInvalidCredentials
	}

	if !CheckPasswordHash(password, user.Password) {
		return nil, ErrInvalidCredentials
	}

	return user, nil
}
