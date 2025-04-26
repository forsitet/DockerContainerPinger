package kafka

import (
	"encoding/json"
	"errors"
	"testing"
	"time"

	"pinger/domain"

	"github.com/IBM/sarama"
	"github.com/IBM/sarama/mocks"
	"github.com/stretchr/testify/assert"
)

// TestPublishSuccess tests successful message publishing
func TestPublishSuccess(t *testing.T) {
	// Create mock producer
	mockProducer := mocks.NewSyncProducer(t, nil)
	mockProducer.ExpectSendMessageAndSucceed()

	// Create our producer with the mock
	producer := &Producer{producer: mockProducer}

	// Test data
	testResult := &domain.PingResult{
		ContainerID:   "test-container",
		ContainerName: "test-app",
		IPAddress:     "192.168.1.1",
		PingTime:      12.34,
		LastSuccess:   time.Now(),
	}

	// Call the method
	err := producer.Publish(testResult)

	// Verify
	assert.NoError(t, err)
	mockProducer.Close()
}

// TestPublishMarshalError tests JSON marshaling failure
func TestPublishMarshalError(t *testing.T) {
	// Create mock producer (not needed for this test case)
	mockProducer := mocks.NewSyncProducer(t, nil)
	mockProducer.Close()

	// Create our producer
	producer := &Producer{producer: mockProducer}

	// Create a value that will fail to marshal
	unmarshalable := make(chan int)
	testResult := &domain.PingResult{
		SomeField: unmarshalable, // assuming you add this field for test
	}

	// Call the method
	err := producer.Publish(testResult)

	// Verify
	assert.Error(t, err)
	assert.Contains(t, err.Error(), "json: unsupported type")
}

// TestPublishSendError tests message sending failure
func TestPublishSendError(t *testing.T) {
	// Create mock producer that expects failure
	mockProducer := mocks.NewSyncProducer(t, nil)
	mockProducer.ExpectSendMessageAndFail(errors.New("kafka send error"))

	// Create our producer with the mock
	producer := &Producer{producer: mockProducer}

	// Test data
	testResult := &domain.PingResult{
		ContainerID:   "test-container",
		ContainerName: "test-app",
		IPAddress:     "192.168.1.1",
		PingTime:      12.34,
		LastSuccess:   time.Now(),
	}

	// Call the method
	err := producer.Publish(testResult)

	// Verify
	assert.Error(t, err)
	assert.Equal(t, "kafka send error", err.Error())
	mockProducer.Close()
}

// TestMessageContent verifies the message content is correct
func TestMessageContent(t *testing.T) {
	// Create mock producer with message content expectation
	mockProducer := mocks.NewSyncProducer(t, nil)
	mockProducer.ExpectSendMessageWithMessageCheckerFunctionAndSucceed(
		func(msg *sarama.ProducerMessage) error {
			// Verify topic
			if msg.Topic != "ping-results" {
				return errors.New("unexpected topic")
			}

			// Verify value
			value, err := msg.Value.Encode()
			if err != nil {
				return err
			}

			var result domain.PingResult
			if err := json.Unmarshal(value, &result); err != nil {
				return err
			}

			if result.ContainerID != "test-container" {
				return errors.New("unexpected container ID")
			}

			return nil
		},
	)

	// Create our producer with the mock
	producer := &Producer{producer: mockProducer}

	// Test data
	testResult := &domain.PingResult{
		ContainerID:   "test-container",
		ContainerName: "test-app",
		IPAddress:     "192.168.1.1",
		PingTime:      12.34,
		LastSuccess:   time.Now(),
	}

	// Call the method
	err := producer.Publish(testResult)

	// Verify
	assert.NoError(t, err)
	mockProducer.Close()
}

// TestNewProducerError tests producer initialization failure
func TestNewProducerError(t *testing.T) {
	// We'll use sarama's mock config to simulate failure
	config := sarama.NewConfig()
	config.Net.DialTimeout = 1 // Set to very low value to force error

	// This should fail because we're not providing any brokers
	_, err := New([]string{})

	// Verify
	assert.Error(t, err)
	assert.Contains(t, err.Error(), "kafka: client has run out of available brokers")
}