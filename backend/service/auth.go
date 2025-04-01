package service

import (
	"back/domain"
	"back/internal/repository"

	"golang.org/x/crypto/bcrypt"
)

type AuthService struct {
	userRepo repository.Object
}

func NewAuthService(userRepo repository.Object) *AuthService {
	return &AuthService{userRepo: userRepo}
}

func HashPassword(password string) (string, error) {
	hashedPassword, err := bcrypt.GenerateFromPassword([]byte(password), bcrypt.DefaultCost)
	if err != nil {
		return "", err
	}
	return string(hashedPassword), nil
}

func CheckPasswordHash(password, hash string) (bool, error) {
	err := bcrypt.CompareHashAndPassword([]byte(hash), []byte(password))
	if err != nil {
		return false, err
	}
	return true, nil
}


func (s *AuthService) Authenticate(username, password string) (*domain.User, error) {
	rawUser, err := s.userRepo.Get(username)
	if err != nil {
		return nil, ErrInvalidCredentials
	}

	user, ok := rawUser.(domain.User)
	if !ok {
		return nil, ErrInvalidCredentials
	}

	return &user, nil
}
