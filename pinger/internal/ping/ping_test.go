package ping

import (
	"errors"
	"testing"
	"time"

	"pinger/domain"
	"pinger/internal/docker"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/mock"
)

// MockDockerClient is a mock implementation of docker.Client
type MockDockerClient struct {
	mock.Mock
}

func (m *MockDockerClient) GetContainerInfos() ([]docker.ContainerInfo, error) {
	args := m.Called()
	return args.Get(0).([]docker.ContainerInfo), args.Error(1)
}

// MockKafkaProducer is a mock implementation of kafka.Producer
type MockKafkaProducer struct {
	mock.Mock
}

func (m *MockKafkaProducer) Publish(result *domain.PingResult) error {
	args := m.Called(result)
	return args.Error(0)
}

func TestPingAllContainers(t *testing.T) {
	tests := []struct {
		name           string
		containerInfos []docker.ContainerInfo
		dockerError    error
		publishError   error
		wantErr        bool
		wantPings      int
	}{
		{
			name: "successful ping of multiple containers",
			containerInfos: []docker.ContainerInfo{
				{
					ID:   "container1",
					Name: "app1",
					IPs:  []string{"192.168.1.1", "192.168.1.2"},
				},
				{
					ID:   "container2",
					Name: "app2",
					IPs:  []string{"192.168.1.3"},
				},
			},
			wantPings: 3,
		},
		{
			name: "container with no IPs is skipped",
			containerInfos: []docker.ContainerInfo{
				{
					ID:   "container1",
					Name: "app1",
					IPs:  []string{},
				},
			},
			wantPings: 0,
		},
		{
			name:        "docker client error",
			dockerError: errors.New("docker error"),
			wantErr:     true,
		},
		{
			name: "kafka publish error",
			containerInfos: []docker.ContainerInfo{
				{
					ID:   "container1",
					Name: "app1",
					IPs:  []string{"192.168.1.1"},
				},
			},
			publishError: errors.New("kafka error"),
			wantPings:    1,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			// Setup mocks
			mockDocker := new(MockDockerClient)
			mockKafka := new(MockKafkaProducer)

			// Expect GetContainerInfos call
			mockDocker.On("GetContainerInfos").Return(tt.containerInfos, tt.dockerError)

			// Expect Publish calls for each IP
			if tt.dockerError == nil {
				for _, container := range tt.containerInfos {
					for _, ip := range container.IPs {
						mockKafka.On("Publish", mock.AnythingOfType("*domain.PingResult")).
							Run(func(args mock.Arguments) {
								result := args.Get(0).(*domain.PingResult)
								assert.Equal(t, container.ID, result.ContainerID)
								assert.Equal(t, container.Name, result.ContainerName)
								assert.Equal(t, ip, result.IPAddress)
								assert.True(t, result.PingTime >= 0)
								assert.False(t, result.LastSuccess.IsZero())
							}).
							Return(tt.publishError)
					}
				}
			}

			// Create service with mocks
			service := &Service{
				dockerClient:  mockDocker,
				kafkaProducer: mockKafka,
				interval:      time.Second,
			}

			// Execute
			service.pingAllContainers()

			// Verify expectations
			mockDocker.AssertExpectations(t)
			if tt.dockerError == nil {
				mockKafka.AssertNumberOfCalls(t, "Publish", tt.wantPings)
			}
		})
	}
}

func TestPingAllContainersWithRealPinger(t *testing.T) {
	// This test uses a real pinger against localhost (requires privileges)
	// It's more of an integration test but can be useful

	if testing.Short() {
		t.Skip("skipping integration test in short mode")
	}

	// Setup test container info
	containerInfos := []docker.ContainerInfo{
		{
			ID:   "test-container",
			Name: "test",
			IPs:  []string{"127.0.0.1"},
		},
	}

	// Setup mocks
	mockDocker := new(MockDockerClient)
	mockKafka := new(MockKafkaProducer)

	// Expect GetContainerInfos call
	mockDocker.On("GetContainerInfos").Return(containerInfos, nil)

	// Expect Publish call
	mockKafka.On("Publish", mock.AnythingOfType("*domain.PingResult")).
		Run(func(args mock.Arguments) {
			result := args.Get(0).(*domain.PingResult)
			assert.Equal(t, "test-container", result.ContainerID)
			assert.Equal(t, "test", result.ContainerName)
			assert.Equal(t, "127.0.0.1", result.IPAddress)
			assert.True(t, result.PingTime > 0)
			assert.False(t, result.LastSuccess.IsZero())
		}).
		Return(nil)

	// Create service with mocks
	service := &Service{
		dockerClient:  mockDocker,
		kafkaProducer: mockKafka,
		interval:      time.Second,
	}

	// Execute
	service.pingAllContainers()

	// Verify expectations
	mockDocker.AssertExpectations(t)
	mockKafka.AssertExpectations(t)
}