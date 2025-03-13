package domain

type User struct {
	ID       string   `json:"id"`
	Username string   `json:"username"`
	Password string   `json:"password"`
	IsAdmin    bool   `json:"isadmin"`
}