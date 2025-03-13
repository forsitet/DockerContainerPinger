// package service

// import (
//     "golang.org/x/crypto/bcrypt"
//     "backend/internal/repository"
//     "backend/domain"
//     "backend/service/errors"
// )

// func HashPassword(password string) (string, error) {
//     hashedPassword, err := bcrypt.GenerateFromPassword([]byte(password), bcrypt.DefaultCost)
//     if err != nil {
//         return "", err
//     }
//     return string(hashedPassword), nil
// }

// func CheckPasswordHash(password, hash string) bool {
//     err := bcrypt.CompareHashAndPassword([]byte(hash), []byte(password))
//     return err == nil
// }

// func Authenticate(username, password string) (*domain.User, string, error) {
//     user, err := repository.GetUserByUsername(username)
//     if err != nil {
//         return nil,  errors.ErrInvalidCredentials
//     }

//     if CheckPasswordHash(password, user.Password) {
//         return nil, errors.ErrInvalidCredentials
//     }


//     return user, nil
// }
package service

import (
	"golang.org/x/crypto/bcrypt"
	"backend/domain"
	"backend/errors"
)

type UserRepository interface {
    GetUserByUsername(username string) (*domain.User, error)
    AddUser(user *domain.User) error
}

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
        return nil, errors.ErrInvalidCredentials
    }

    if !CheckPasswordHash(password, user.Password) {
        return nil, errors.ErrInvalidCredentials
    }

    return user, nil
}
// func (s *AuthService) Authenticate(username, password string) (*domain.User, error) {
//     user, err := s.userRepo.GetUserByUsername(username)
//     if err != nil {
//         return nil, errors.ErrInvalidCredentials
//     }

//     if !CheckPasswordHash(password, user.Password) {
//         return nil, errors.ErrInvalidCredentials
//     }

//     return user, nil
// }

// func Authenticate(username, password string) (*domain.User, error) {
// 	user, err := s.userRepo.GetUserByUsername(username)
// 	if err != nil {
// 		return nil, service.ErrInvalidCredentials
// 	}

// 	if !CheckPasswordHash(password, user.Password) {
// 		return nil, service.ErrInvalidCredentials
// 	}

// 	return user, nil
// }