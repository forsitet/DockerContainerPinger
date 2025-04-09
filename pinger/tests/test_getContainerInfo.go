// package tests

// import (
// 	"context"
// 	"testing"

// 	"github.com/docker/docker/api/types"
// 	"github.com/docker/docker/client"
// 	"github.com/stretchr/testify/assert"
// 	"github.com/stretchr/testify/mock"
// 	"pinger/cmd"
// )

// type MockDockerClient struct {
// 	mock.Mock
// 	client.APIClient
// }

// func (m *MockDockerClient) ContainerList(ctx context.Context, options types.ContainerListOptions) ([]types.Container, error) {
// 	args := m.Called(ctx, options)
// 	return args.Get(0).([]types.Container), args.Error(1)
// }

// func TestGetContainerInfo(t *testing.T) {
// 	mockClient := new(MockDockerClient)

// 	// Mock данные
// 	containers := []types.Container{
// 		{
// 			ID:    "test123",
// 			Names: []string{"/test-container"},
// 			NetworkSettings: &types.SummaryNetworkSettings{
// 				Networks: map[string]*types.EndpointSettings{
// 					"bridge": {IPAddress: "172.17.0.2"},
// 				},
// 			},
// 		},
// 	}

// 	// Настройка мока
// 	mockClient.On(
// 		"ContainerList",
// 		mock.Anything,
// 		mock.Anything,
// 	).Return(containers, nil)

// 	// Вызов функции
// 	result, err := cmd.GetContainerInfo(mockClient)

// 	// Проверки
// 	assert.NoError(t, err)
// 	assert.Equal(t, "test-container", result["test123"].Name)
// 	assert.Equal(t, []string{"172.17.0.2"}, result["test123"].IPs)
// }