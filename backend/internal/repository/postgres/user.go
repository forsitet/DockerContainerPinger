package postgres

import (
	"errors"
	"log"

	"gorm.io/gorm"

	"back/domain"
	"back/internal/repository"
)

type UserRepo struct {
	data *gorm.DB
}

func NewUserRepo(data *gorm.DB) *UserRepo {
	if err := data.AutoMigrate(&domain.User{}); err != nil {
		log.Fatal("Migration error:", err)
	}

	return &UserRepo{data: data}
}

func (u *UserRepo) Get(key string) (any, error) {
	var user domain.User
	if err := u.data.Where("username = ?", key).First(&user).Error; err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return nil, repository.ErrKeyNotFound
		}
		return nil, err
	}
	return user, nil
}

func (u *UserRepo) Post(key string, value any) error {
	if err := u.data.Create(value).Error; err != nil {
		return err
	}
	return nil
}

func (u *UserRepo) Put(key string, value any) error {
	result := u.data.Model(&domain.User{}).Where("username = ?", key).Updates(value)
	if result.Error != nil {
		return result.Error
	}
	if result.RowsAffected == 0 {
		return repository.ErrKeyNotFound
	}
	return nil
}

func (u *UserRepo) Delete(key string) error {
	result := u.data.Where("uesrname = ?", key).Delete(&domain.User{})
	if result.Error != nil {
		return result.Error
	}
	if result.RowsAffected == 0 {
		return repository.ErrKeyNotFound
	}
	return nil
}
