// docker_test.go
package docker

import (
	"context"
	"pinger/domain/model"
	"testing"

	"github.com/docker/docker/api/types"
	"github.com/docker/docker/api/types/network"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/mock"
)

func TestNew(t *testing.T) {
	t.Run("successful creation", func(t *testing.T) {
		repo, err := New()
		if err != nil {
			t.Skip("Docker not available, skipping test")
		}
		assert.NoError(t, err)
		assert.NotNil(t, repo)
	})

	t.Run("creation error", func(t *testing.T) {
		mockClient := &MockDockerClient{}
		mockClient.On("Close").Return(nil)

		repo := NewWithClient(mockClient)
		assert.NotNil(t, repo)
	})
}

func TestConvertToContainerInfo(t *testing.T) {
	tests := []struct {
		name      string
		container types.Container
		expected  model.ContainerInfo
	}{
		{
			name: "container with name and single IP",
			container: types.Container{
				ID:    "test123",
				Names: []string{"/test-container"},
				NetworkSettings: &types.SummaryNetworkSettings{
					Networks: map[string]*network.EndpointSettings{
						"bridge": {IPAddress: "172.17.0.2"},
					},
				},
			},
			expected: model.ContainerInfo{
				ID:   "test123",
				Name: "test-container",
				IPs:  []string{"172.17.0.2"},
			},
		},
		{
			name: "container without name (should use ID prefix)",
			container: types.Container{
				ID:    "abcdef1234567890",
				Names: []string{},
			},
			expected: model.ContainerInfo{
				ID:   "abcdef1234567890",
				Name: "abcdef123456",
				IPs:  nil,
			},
		},
		{
			name: "container with multiple networks",
			container: types.Container{
				ID:    "multi-net",
				Names: []string{"/multi-network-container"},
				NetworkSettings: &types.SummaryNetworkSettings{
					Networks: map[string]*network.EndpointSettings{
						"bridge":  {IPAddress: "172.17.0.3"},
						"network1": {IPAddress: "10.0.0.1"},
						"network2": {IPAddress: "192.168.1.1"},
					},
				},
			},
			expected: model.ContainerInfo{
				ID:   "multi-net",
				Name: "multi-network-container",
				IPs:  []string{"172.17.0.3", "10.0.0.1", "192.168.1.1"},
			},
		},
		{
			name: "container with nil network settings",
			container: types.Container{
				ID:    "no-net-settings",
				Names: []string{"/no-net"},
				NetworkSettings: nil,
			},
			expected: model.ContainerInfo{
				ID:   "no-net-settings",
				Name: "no-net",
				IPs:  nil,
			},
		},
		{
			name: "container with empty network settings",
			container: types.Container{
				ID:    "empty-net",
				Names: []string{"/empty-net"},
				NetworkSettings: &types.SummaryNetworkSettings{
					Networks: map[string]*network.EndpointSettings{},
				},
			},
			expected: model.ContainerInfo{
				ID:   "empty-net",
				Name: "empty-net",
				IPs:  nil,
			},
		},
		{
			name: "container with multiple names (should use first name)",
			container: types.Container{
				ID:    "multi-name",
				Names: []string{"/first-name", "/second-name"},
				NetworkSettings: &types.SummaryNetworkSettings{
					Networks: map[string]*network.EndpointSettings{
						"bridge": {IPAddress: "172.17.0.4"},
					},
				},
			},
			expected: model.ContainerInfo{
				ID:   "multi-name",
				Name: "first-name",
				IPs:  []string{"172.17.0.4"},
			},
		},
		{
			name: "container with network but no IP address",
			container: types.Container{
				ID:    "no-ip",
				Names: []string{"/no-ip-container"},
				NetworkSettings: &types.SummaryNetworkSettings{
					Networks: map[string]*network.EndpointSettings{
						"bridge": {IPAddress: ""}, // Пустой IP
					},
				},
			},
			expected: model.ContainerInfo{
				ID:   "no-ip",
				Name: "no-ip-container",
				IPs:  nil,
			},
		},
		{
			name: "container with leading/trailing spaces in name",
			container: types.Container{
				ID:    "spaced-name",
				Names: []string{"spaced-container"},
				NetworkSettings: &types.SummaryNetworkSettings{
					Networks: map[string]*network.EndpointSettings{
						"bridge": {IPAddress: "172.17.0.5"},
					},
				},
			},
			expected: model.ContainerInfo{
				ID:   "spaced-name",
				Name: "spaced-container",
				IPs:  []string{"172.17.0.5"},
			},
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			result := convertToContainerInfo(tt.container)
			assert.Equal(t, tt.expected, result, "Test case: %s", tt.name)
			
			if len(tt.expected.IPs) > 0 {
				assert.Equal(t, len(tt.expected.IPs), len(result.IPs))
				for i, ip := range tt.expected.IPs {
					assert.Equal(t, ip, result.IPs[i])
				}
			} else {
				assert.Nil(t, result.IPs)
			}
		})
	}
}

func TestGetContainerInfos(t *testing.T) {
	t.Run("success", func(t *testing.T) {
		mockClient := &MockDockerClient{}
		repo := &dockerRepository{client: mockClient}

		expectedContainers := []types.Container{
			{
				ID:    "test1",
				Names: []string{"/container1"},
				NetworkSettings: &types.SummaryNetworkSettings{
					Networks: map[string]*network.EndpointSettings{
						"bridge": {IPAddress: "172.17.0.2"},
					},
				},
			},
		}

		mockClient.On("ContainerList", mock.Anything, mock.Anything).
			Return(expectedContainers, nil).
			Once()

		result, err := repo.GetContainerInfos(context.Background())
		assert.NoError(t, err)
		assert.Equal(t, map[string]model.ContainerInfo{
			"test1": {
				ID:   "test1",
				Name: "container1",
				IPs:  []string{"172.17.0.2"},
			},
		}, result)

		mockClient.AssertExpectations(t)
	})

	t.Run("error", func(t *testing.T) {
		mockClient := &MockDockerClient{}
		repo := &dockerRepository{client: mockClient}

		mockClient.On("ContainerList", mock.Anything, mock.Anything).
			Return([]types.Container{}, assert.AnError).
			Once()

		result, err := repo.GetContainerInfos(context.Background())
		assert.Error(t, err)
		assert.Nil(t, result)

		mockClient.AssertExpectations(t)
	})
}
