package ping

import (
	"context"
	"errors"
	"testing"
	"time"

	"github.com/prometheus-community/pro-bing"
	"github.com/stretchr/testify/mock"
	"pinger/domain/model"
)

type MockPinger struct {
	mock.Mock
}

func (m *MockPinger) Run() error {
	args := m.Called()
	return args.Error(0)
}

func (m *MockPinger) OnFinish(f func(*probing.Statistics)) {
	m.Called(f)
}

type MockDockerRepo struct {
	mock.Mock
}

func (m *MockDockerRepo) GetContainerInfos(ctx context.Context) (map[string]model.ContainerInfo, error) {
	args := m.Called(ctx)
	return args.Get(0).(map[string]model.ContainerInfo), args.Error(1)
}

func (m *MockDockerRepo) Close() error {
	args := m.Called()
	return args.Error(0)
}

type MockPingRepo struct {
	mock.Mock
}

func (m *MockPingRepo) Publish(ctx context.Context, result *model.PingResult) error {
	args := m.Called(ctx, result)
	return args.Error(0)
}

func (m *MockPingRepo) Close() error {
	args := m.Called()
	return args.Error(0)
}

func TestPingContainers(t *testing.T) {
    testContainer := model.ContainerInfo{
        ID:   "container1",
        Name: "test-container",
        IPs:  []string{"192.168.1.1"},
    }

    tests := []struct {
        name          string
        prepareMocks  func(*MockDockerRepo, *MockPingRepo, *MockPinger)
        expectedError bool
    }{
        {
            name: "successful ping",
            prepareMocks: func(d *MockDockerRepo, p *MockPingRepo, ping *MockPinger) {
                d.On("GetContainerInfos", mock.Anything).
                    Return(map[string]model.ContainerInfo{"container1": testContainer}, nil)

                ping.On("Run").Return(nil)
                ping.On("OnFinish", mock.AnythingOfType("func(*probing.Statistics)")).
                    Run(func(args mock.Arguments) {
                        stats := &probing.Statistics{
                            PacketsSent: 3,
                            PacketsRecv: 3,
                            AvgRtt:      10 * time.Millisecond,
                        }
                        args.Get(0).(func(*probing.Statistics))(stats)
                    })

                p.On("Publish", mock.Anything, mock.MatchedBy(func(r *model.PingResult) bool {
                    return r.ContainerID == "container1" && r.PingTime == 10.0
                })).Return(nil)
            },
        },
        {
            name: "docker error",
            prepareMocks: func(d *MockDockerRepo, p *MockPingRepo, ping *MockPinger) {
                d.On("GetContainerInfos", mock.Anything).
                    Return(map[string]model.ContainerInfo{}, errors.New("docker error"))
            },
            expectedError: true,
        },
        {
            name: "ping error",
            prepareMocks: func(d *MockDockerRepo, p *MockPingRepo, ping *MockPinger) {
                d.On("GetContainerInfos", mock.Anything).
                    Return(map[string]model.ContainerInfo{"container1": testContainer}, nil)

                ping.On("Run").Return(errors.New("ping failed"))
                ping.On("OnFinish", mock.AnythingOfType("func(*probing.Statistics)")) // Добавлено
            },
        },
    }

    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            dockerRepo := new(MockDockerRepo)
            pingRepo := new(MockPingRepo)
            mockPinger := new(MockPinger)

            tt.prepareMocks(dockerRepo, pingRepo, mockPinger)

            service := &Service{
                dockerRepo: dockerRepo,
                pingRepo:   pingRepo,
                interval:   time.Second,
                newPinger: func(ip string) (PingerInterface, error) {
                    return mockPinger, nil
                },
            }

            service.pingContainers(context.Background())

            dockerRepo.AssertExpectations(t)
            pingRepo.AssertExpectations(t)
            mockPinger.AssertExpectations(t)
        })
    }
}