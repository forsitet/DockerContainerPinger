package postgres

import (
	"back/domain"
	"database/sql"
	"log"
	"time"
)

type preparedStatements struct {
	insertPing           *sql.Stmt //Post
	getPingResults       *sql.Stmt //Get
	deleteOldPingResults *sql.Stmt // Delete
}

type PingRepository struct {
	DB    *sql.DB
	stmts *preparedStatements
}

func NewPingRepository(db *sql.DB) *PingRepository {
	InitPingTables(db)
	stmts := newPreparedStatements(db)
	return &PingRepository{
		DB:    db,
		stmts: stmts,
	}
}

func newPreparedStatements(db *sql.DB) *preparedStatements {
	const op = "repository.postgres.NewPreparedStatements"
	stmts := &preparedStatements{}
	var err error

	stmts.getPingResults, err = db.Prepare(`
		SELECT ip_address, container_name, ping_time, last_success
		FROM pings
		ORDER BY id DESC LIMIT $1
	`)
	if err != nil {
		log.Println(op, "getPingResults: ", err)
	}

	stmts.insertPing, err = db.Prepare(`
		INSERT INTO pings (ip_address, container_name, ping_time, last_success)
		VALUES ($1, $2, $3, $4)
		ON CONFLICT (ip_address) DO UPDATE
		SET container_name = EXCLUDED.container_name,
			ping_time = EXCLUDED.ping_time,
			last_success = EXCLUDED.last_success
	`)
	if err != nil {
		log.Println(op, "insertPing: ", err)
	}

	stmts.deleteOldPingResults, err = db.Prepare("DELETE FROM pings WHERE last_success < $1")
	if err != nil {
		log.Println(op, "deleteOldPingResults: ", err)
	}

	return stmts
}

func (r *PingRepository) Get(limit int) ([]domain.Ping, error) {
	const op = "repository.postgres.Get"
	rows, err := r.stmts.getPingResults.Query(limit)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	pings := make([]domain.Ping, 0)
	for rows.Next() {
		var p domain.Ping
		err := rows.Scan(&p.IPAddress, &p.ContainerName, &p.PingTime, &p.LastSuccess)
		if err != nil {
			log.Println(op, err)
			continue
		}
		pings = append(pings, p)
	}
	return pings, nil
}

func (r *PingRepository) Post(pr domain.Ping) error {
	_, err := r.stmts.insertPing.Exec(pr.IPAddress, pr.ContainerName, pr.PingTime, pr.LastSuccess)
	return err

}

func (r *PingRepository) Delete(before time.Time) error {
	_, err := r.stmts.deleteOldPingResults.Exec(before)
	return err
}
