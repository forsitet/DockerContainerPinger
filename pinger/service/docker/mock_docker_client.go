package docker

import (
	"context"

	"github.com/docker/docker/api/types"
	"github.com/docker/docker/api/types/container"
)

type MockDockerClient struct {
	Containers []types.Container
	Err        error
}

func (m *MockDockerClient) ContainerList(ctx context.Context, options container.ListOptions) ([]types.Container, error) {
	return m.Containers, m.Err
}

func (m *MockDockerClient) Close() error {
	return nil
}