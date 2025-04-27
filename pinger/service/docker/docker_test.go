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
	"pinger/domain/model"
)

type MockDockerInterface struct {
	mock.Mock
}

func (m *MockDockerInterface) ContainerList(ctx context.Context, options container.ListOptions) ([]types.Container, error) {
	args := m.Called(ctx, options)
	return args.Get(0).([]types.Container), args.Error(1)
}

func (m *MockDockerInterface) Close() error {
	args := m.Called()
	return args.Error(0)
}

func TestGetContainerInfos(t *testing.T) {
	tests := []struct {
		name           string
		mockContainers []types.Container
		mockError      error
		expected       map[string]model.ContainerInfo
		expectedError  string
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
			expected: map[string]model.ContainerInfo{
				"container1": {
					ID:   "container1",
					Name: "test-container",
					IPs:  []string{"172.17.0.2"},
				},
			},
		},
		{
			name: "container without network settings",
			mockContainers: []types.Container{
				{
					ID:    "container2",
					Names: []string{"/no-network"},
				},
			},
			expected: map[string]model.ContainerInfo{
				"container2": {
					ID:   "container2",
					Name: "no-network",
					IPs:  []string{},
				},
			},
		},
		{
			name: "container with multiple networks",
			mockContainers: []types.Container{
				{
					ID:    "container3",
					Names: []string{"/multi-net"},
					NetworkSettings: &types.SummaryNetworkSettings{
						Networks: map[string]*network.EndpointSettings{
							"bridge": {
								IPAddress: "172.17.0.3",
							},
							"custom": {
								IPAddress: "192.168.1.2",
							},
						},
					},
				},
			},
			expected: map[string]model.ContainerInfo{
				"container3": {
					ID:   "container3",
					Name: "multi-net",
					IPs:  []string{"172.17.0.3", "192.168.1.2"},
				},
			},
		},
		{
			name:          "docker api error",
			mockError:     errors.New("api error"),
			expectedError: "api error",
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			mockClient := new(MockDockerInterface)
			mockClient.On("ContainerList", mock.Anything, mock.Anything).
				Return(tt.mockContainers, tt.mockError)

			client := &Client{
				cli: mockClient,
			}

			result, err := client.GetContainerInfos(context.Background())

			if tt.expectedError != "" {
				assert.ErrorContains(t, err, tt.expectedError)
				assert.Nil(t, result)
			} else {
				assert.NoError(t, err)
				assert.Equal(t, tt.expected, result)
			}

			mockClient.AssertExpectations(t)
		})
	}
}

func TestNewClient(t *testing.T) {
	t.Run("successful connection", func(t *testing.T) {
		client, err := New()
		assert.NoError(t, err)
		assert.NotNil(t, client)
	})

	// t.Run("connection error", func(t *testing.T) {
	// })
}