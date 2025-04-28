package repository

import (
	"context"
	"pinger/domain/model"
)

type PingRepository interface {
    Publish(ctx context.Context, result *model.PingResult) error
    Close() error
}
