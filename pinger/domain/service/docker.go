package service

import (
	"context"
	"github.com/docker/docker/api/types/container"
	"github.com/docker/docker/api/types"
)

type DockerClient interface {
	ContainerList(ctx context.Context, options container.ListOptions) ([]types.Container, error)
	Close() error
}
