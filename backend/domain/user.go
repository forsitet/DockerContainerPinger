package domain

type User struct {
	ID       string `json:"id" gorm:"primaryKey"`
	Username string `json:"username" gorm:"unique;not null"`
	Password string `json:"password" gorm:"not null"`
	IsAdmin  bool   `json:"isadmin" gorm:"default:0"`
}
