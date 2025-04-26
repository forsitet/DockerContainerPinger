package kafka

import (
	"encoding/json"

	"github.com/IBM/sarama"
	"pinger/domain"
)

// Producer обертка для Kafka продюсера
type Producer struct {
	producer sarama.SyncProducer
}

// New создает новый Kafka продюсер
func New(brokers []string) (*Producer, error) {
	config := sarama.NewConfig()
	config.Producer.Return.Successes = true

	producer, err := sarama.NewSyncProducer(brokers, config)
	if err != nil {
		return nil, err
	}

	return &Producer{producer: producer}, nil
}

// Publish публикует результат пинга в Kafka
func (p *Producer) Publish(result *domain.PingResult) error {
	data, err := json.Marshal(result)
	if err != nil {
		return err
	}

	msg := &sarama.ProducerMessage{
		Topic: "ping-results",
		Value: sarama.ByteEncoder(data),
	}

	_, _, err = p.producer.SendMessage(msg)
	return err
}

// Close закрывает соединение с Kafka
func (p *Producer) Close() error {
	return p.producer.Close()
}