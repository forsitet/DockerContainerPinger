package postgres

import (
	"database/sql"
	"log"

	_ "github.com/lib/pq"
)

func CreatePingRepository(dbName string, db *sql.DB) {
	var exists bool
	query := `SELECT EXISTS (SELECT 1 FROM pg_database WHERE datname = $1)`
	if err := db.QueryRow(query, dbName).Scan(&exists); err != nil {
		log.Fatal("error checking the existence of the database", err)
	}
	if exists {
		log.Printf("DB %q already exists\n", dbName)
	} else {
		log.Printf("Creating a database %q\n", dbName)
		_, err := db.Exec("CREATE DATABASE " + dbName)
		if err != nil {
			log.Fatal("error when creating the database\n", err)
		} else {
			log.Printf("database %q was created successfully\n", dbName)
		}
	}
}

func InitPingTables(db *sql.DB) {
	_, err := db.Exec(`
		CREATE TABLE IF NOT EXISTS pings (
			id SERIAL PRIMARY KEY,
			ip_address TEXT UNIQUE,
			container_name TEXT,
			ping_time DOUBLE PRECISION,
			last_success TIMESTAMP
		);
	`)
	if err != nil {
		log.Fatal("error creating the table")
	}

}
