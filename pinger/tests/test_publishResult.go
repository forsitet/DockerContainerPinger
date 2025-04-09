// kafka_test.go
package main

import (
	"testing"
	"time"

	"github.com/IBM/sarama"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/mock"
)

type MockSyncProducer struct {
	mock.Mock
	sarama.SyncProducer
}

func (m *MockSyncProducer) SendMessage(msg *sarama.ProducerMessage) (int32, int64, error) {
	args := m.Called(msg)
	return int32(args.Int(0)), int64(args.Int(1)), args.Error(2)
}

func TestPublishResult(t *testing.T) {
	mockProducer := new(MockSyncProducer)
	
	testPing := &Ping{
		ContainerID:   "test1",
		ContainerName: "container1",
		IPAddress:     "172.17.0.2",
		PingTime:      42.5,
		LastSuccess:   time.Now(),
	}

	// Настройка мока
	mockProducer.On(
		"SendMessage",
		mock.AnythingOfType("*sarama.ProducerMessage"),
	).Return(0, 0, nil)

	// Вызов тестируемой функции
	err := publishResult(mockProducer, testPing)

	// Проверки
	assert.NoError(t, err)
	mockProducer.AssertExpectations(t)
}