package kafka

import (
	"encoding/json"
	"pinger/domain"

	"github.com/IBM/sarama"
)

func PublishResult(producer sarama.SyncProducer, result *domain.PingResult) error {
	data, err := json.Marshal(result)
	if err != nil {
		return err
	}

	msg := &sarama.ProducerMessage{
		Topic: "ping",
		Value: sarama.ByteEncoder(data),
	}

	_, _, err = producer.SendMessage(msg)
	return err
}
