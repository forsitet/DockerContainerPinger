// docker_test.go
package main

import (
	"context"
	"testing"

	"github.com/docker/docker/api/types"
	"github.com/docker/docker/client"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/mock"
)

type MockDockerClient struct {
	mock.Mock
	client.APIClient
}

func (m *MockDockerClient) ContainerList(ctx context.Context, options types.ContainerListOptions) ([]types.Container, error) {
	args := m.Called(ctx, options)
	return args.Get(0).([]types.Container), args.Error(1)
}

func TestGetContainerInfos(t *testing.T) {
	mockClient := new(MockDockerClient)
	
	// Mock данные
	containers := []types.Container{
		{
			ID:    "test1",
			Names: []string{"/container1"},
			NetworkSettings: &types.SummaryNetworkSettings{
				Networks: map[string]*types.EndpointSettings{
					"bridge": {IPAddress: "172.17.0.2"},
				},
			},
		},
	}
	
	// Настройка мока
	mockClient.On(
		"ContainerList",
		mock.Anything,
		mock.Anything,
	).Return(containers, nil)

	// Вызов тестируемой функции
	result, err := getContainerInfos(mockClient)

	// Проверки
	assert.NoError(t, err)
	assert.Equal(t, 1, len(result))
	assert.Equal(t, "container1", result["test1"].Name)
	assert.Equal(t, []string{"172.17.0.2"}, result["test1"].IPs)
}