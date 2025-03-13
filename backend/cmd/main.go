package main

import (
	"back/internal/repository/postgres"
	"fmt"
)

func main() {
	db := postgres.InitDB()
	objectUserRepo := postgres.NewUserRepo(db)
	fmt.Println(objectUserRepo)
}
