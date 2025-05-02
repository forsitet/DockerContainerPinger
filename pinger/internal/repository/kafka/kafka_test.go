package kafka

import (
	"context"
	"encoding/json"
	"errors"
	"pinger/domain/model"
	"testing"
	"time"

	"github.com/IBM/sarama"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/mock"
)

type MockSyncProducer struct {
    mock.Mock
}

func (m *MockSyncProducer) SendMessage(msg *sarama.ProducerMessage) (int32, int64, error) {
    args := m.Called(msg)
    return args.Get(0).(int32), args.Get(1).(int64), args.Error(2)
}

func (m *MockSyncProducer) SendMessages(msgs []*sarama.ProducerMessage) error {
    args := m.Called(msgs)
    return args.Error(0)
}

func (m *MockSyncProducer) Close() error {
    args := m.Called()
    return args.Error(0)
}

func (m *MockSyncProducer) BeginTxn() error {
    args := m.Called()
    return args.Error(0)
}

func (m *MockSyncProducer) CommitTxn() error {
    args := m.Called()
    return args.Error(0)
}

func (m *MockSyncProducer) AbortTxn() error {
    args := m.Called()
    return args.Error(0)
}

func (m *MockSyncProducer) TxnStatus() sarama.ProducerTxnStatusFlag {
    args := m.Called()
    return args.Get(0).(sarama.ProducerTxnStatusFlag)
}

func (m *MockSyncProducer) AddMessageToTxn(msg *sarama.ConsumerMessage, groupID string, metadata *string) error {
    args := m.Called(msg, groupID, metadata)
    return args.Error(0)
}

func (m *MockSyncProducer) AddOffsetToTxn(offset int64, topic string, partition int32, groupID string, metadata *string) error {
    args := m.Called(offset, topic, partition, groupID, metadata)
    return args.Error(0)
}

func (m *MockSyncProducer) AddOffsetsToTxn(offsets map[string][]*sarama.PartitionOffsetMetadata, groupID string) error {
    args := m.Called(offsets, groupID)
    return args.Error(0)
}

func (m *MockSyncProducer) IsTransactional() bool {
    args := m.Called()
    return args.Bool(0)
}
func TestProducer_Publish_Success(t *testing.T) {

    mockProducer := new(MockSyncProducer)
    
    producer := &Producer{producer: mockProducer}

    testTime := time.Now()
    testResult := &model.PingResult{
        ContainerID:   "container-123",
        ContainerName: "my-container",
        IPAddress:     "192.168.1.1",
        PingTime:      12.34,
        LastSuccess:   testTime,
    }

    expectedData, err := json.Marshal(testResult)
    assert.NoError(t, err)

    mockProducer.On("SendMessage", &sarama.ProducerMessage{
        Topic: "ping-results",
        Value: sarama.ByteEncoder(expectedData),
    }).Return(int32(0), int64(0), nil)

    err = producer.Publish(context.Background(), testResult)

    assert.NoError(t, err)
    mockProducer.AssertExpectations(t)
}
func TestProducer_Publish_SendMessageError(t *testing.T) {
	mockProducer := new(MockSyncProducer)
	producer := &Producer{producer: mockProducer}

	testTime := time.Now()
	testResult := &model.PingResult{
		ContainerID:   "container-456",
		ContainerName: "another-container",
		IPAddress:     "10.0.0.1",
		PingTime:      56.78,
		LastSuccess:   testTime,
	}

	expectedData, err := json.Marshal(testResult)
	assert.NoError(t, err)

	expectedErr := errors.New("kafka send error")
	mockProducer.On("SendMessage", &sarama.ProducerMessage{
		Topic: "ping-results",
		Value: sarama.ByteEncoder(expectedData),
	}).Return(int32(0), int64(0), expectedErr)

	err = producer.Publish(context.Background(), testResult)

	assert.EqualError(t, err, expectedErr.Error())
	mockProducer.AssertExpectations(t)
}

func TestProducer_Publish_EmptyValues(t *testing.T) {
	mockProducer := new(MockSyncProducer)
	producer := &Producer{producer: mockProducer}

	testResult := &model.PingResult{
		ContainerID:   "",
		ContainerName: "",
		IPAddress:     "",
		PingTime:      0,
		LastSuccess:   time.Time{},
	}

	expectedData, err := json.Marshal(testResult)
	assert.NoError(t, err)

	mockProducer.On("SendMessage", &sarama.ProducerMessage{
		Topic: "ping-results",
		Value: sarama.ByteEncoder(expectedData),
	}).Return(int32(0), int64(0), nil)

	err = producer.Publish(context.Background(), testResult)

	assert.NoError(t, err)
	mockProducer.AssertExpectations(t)
}