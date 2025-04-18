package tests

// import (
// 	"sync"
// 	"testing"
// 	"time"

// 	"github.com/go-ping/ping"
// 	"github.com/stretchr/testify/assert"
// 	"your_project/cmd"
// )

// type MockPinger struct {
// 	mock.Mock
// 	ping.Pinger
// }

// func (m *MockPinger) Run() error {
// 	args := m.Called()
// 	return args.Error(0)
// }

// func (m *MockPinger) Statistics() *ping.Statistics {
// 	return &ping.Statistics{AvgRtt: time.Millisecond * 42}
// }

// func TestPingContainer(t *testing.T) {
// 	var wg sync.WaitGroup
// 	results := make(chan *cmd.Ping, 1)
// 	wg.Add(1)

// 	// Вызов функции
// 	go cmd.PingContainer("127.0.0.1", "test123", "test-container", &wg, results)

// 	// Ожидание результата
// 	wg.Wait()
// 	close(results)

// 	// Проверки
// 	result := <-results
// 	assert.Equal(t, "test123", result.ContainerID)
// 	assert.Equal(t, 42.0, result.PingTime)
// }