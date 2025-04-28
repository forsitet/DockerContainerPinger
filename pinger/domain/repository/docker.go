package repository

import (
	"context"
	"pinger/domain/model"
)

type DockerRepository interface {
    GetContainerInfos(ctx context.Context) (map[string]model.ContainerInfo, error)
	Close() error
}