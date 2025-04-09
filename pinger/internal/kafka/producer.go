package kafka

import (
	"encoding/json"

	"github.com/IBM/sarama"
)

type Producer struct {
    producer sarama.SyncProducer
}

// New создает продюсера Kafka.
func New(brokers []string) (*Producer, error) {
    config := sarama.NewConfig()
    config.Producer.Return.Successes = true

    producer, err := sarama.NewSyncProducer(brokers, config)
    return &Producer{producer: producer}, err
}

// Send отправляет сообщение в Kafka.
func (p *Producer) Send(topic string, message interface{}) error {
    data, err := json.Marshal(message)
    if err != nil {
        return err
    }

    msg := &sarama.ProducerMessage{
        Topic: topic,
        Value: sarama.ByteEncoder(data),
    }

    _, _, err = p.producer.SendMessage(msg)
    return err
}