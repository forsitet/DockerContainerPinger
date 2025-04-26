package docker

import (
	"context"
	"errors"
	"testing"

	"github.com/docker/docker/api/types"
	"github.com/docker/docker/api/types/container"
	"github.com/docker/docker/api/types/network"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/mock"
	"pinger/domain"
)

// MockDockerInterface мок для Docker API
type MockDockerInterface struct {
	mock.Mock
}

func (m *MockDockerInterface) ContainerList(ctx context.Context, options container.ListOptions) ([]types.Container, error) {
	args := m.Called(ctx, options)
	return args.Get(0).([]types.Container), args.Error(1)
}

func TestGetContainerInfos(t *testing.T) {
	tests := []struct {
		name          string
		mockContainers []types.Container
		mockError     error
		expected      map[string]domain.ContainerInfo
		expectedError string
	}{
		{
			name: "success with single container",
			mockContainers: []types.Container{
				{
					ID:    "container1",
					Names: []string{"/test-container"},
					NetworkSettings: &types.SummaryNetworkSettings{
						Networks: map[string]*network.EndpointSettings{
							"bridge": {
								IPAddress: "172.17.0.2",
							},
						},
					},
				},
			},
			expected: map[string]domain.ContainerInfo{
				"container1": {
					ID:   "container1",
					Name: "test-container",
					IPs:  []string{"172.17.0.2"},
				},
			},
		},
		{
			name: "docker api error",
			mockError:     errors.New("api error"),
			expectedError: "api error",
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			// Создаем мок
			mockClient := new(MockDockerInterface)
			mockClient.On("ContainerList", mock.Anything, mock.Anything).
				Return(tt.mockContainers, tt.mockError)

			// Создаем наш клиент с моком
			client := &Client{
				cli: mockClient,
			}

			// Вызываем тестируемую функцию
			result, err := client.GetContainerInfos()

			// Проверки
			if tt.expectedError != "" {
				assert.ErrorContains(t, err, tt.expectedError)
			} else {
				assert.NoError(t, err)
				assert.Equal(t, tt.expected, result)
			}

			// Проверяем, что ожидаемые методы были вызваны
			mockClient.AssertExpectations(t)
		})
	}
}