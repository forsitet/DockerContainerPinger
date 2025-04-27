package kafka

import (
    "context"
    "encoding/json"
    
    "pinger/domain/model"
    "pinger/domain/repository"
    
    "github.com/IBM/sarama"
)

type Producer struct {
    producer sarama.SyncProducer
}

func New(brokers []string) (repository.PingRepository, error) {
    config := sarama.NewConfig()
    config.Producer.Return.Successes = true

    producer, err := sarama.NewSyncProducer(brokers, config)
    if err != nil {
        return nil, err
    }

    return &Producer{producer: producer}, nil
}

func (p *Producer) Publish(ctx context.Context, result *model.PingResult) error {
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

func (p *Producer) Close() error {
    return p.producer.Close()
}