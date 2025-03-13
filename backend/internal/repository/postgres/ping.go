package postgres

import (
	"gorm.io/gorm"
	"back/domain"
)

type PingRepository struct {
	DB *gorm.DB
}

func NewPingRepository(db *gorm.DB) (*PingRepository, error) {
	if err := db.AutoMigrate(&domain.Ping{}); err != nil {
		return nil, err
	}
	return &PingRepository{DB: db}, nil
}

func (r *PingRepository) Get(key string) (any, error) {
	var ping domain.Ping
	if err := r.DB.Where("ip_address = ?", key).First(&ping).Error; err != nil {
		return nil, err
	}
	return ping, nil
}

func (r *PingRepository) Post(key string, value any) error {
	ping, ok := value.(domain.Ping)
	if !ok {
		return gorm.ErrInvalidData
	}
	ping.IPAddress = key
	return r.DB.Create(&ping).Error
}

func (r *PingRepository) Put(key string, value any) error {
	ping, ok := value.(domain.Ping)
	if !ok {
		return gorm.ErrInvalidData
	}
	ping.IPAddress = key
	return r.DB.Where("ip_address = ?", key).Save(&ping).Error
}

func (r *PingRepository) Delete(key string) error {
	return r.DB.Where("ip_address = ?", key).Delete(&domain.Ping{}).Error
}
