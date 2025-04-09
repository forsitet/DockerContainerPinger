package kafka

import (
	"back/domain"
	"back/internal/repository/postgres"
	"context"
	"encoding/json"
	"log"

	"github.com/IBM/sarama"
)

type Consumer struct {
	Repo *postgres.PingRepository
}

type ConsumerGroupHandler struct {
	Consumer *Consumer
}

func (h *ConsumerGroupHandler) Setup(_ sarama.ConsumerGroupSession) error {
	return nil
}

func (h *ConsumerGroupHandler) Cleanup(_ sarama.ConsumerGroupSession) error {
	return nil
}

func (h *ConsumerGroupHandler) ConsumeClaim(session sarama.ConsumerGroupSession, claim sarama.ConsumerGroupClaim) error {
	const op = "repository.kafka.ConsumeClaim"
	for message := range claim.Messages() {
		log.Printf("Message received: topic=%s, partition=%d, offset=%d", message.Topic, message.Partition, message.Offset)

		var ping domain.Ping

		if err := json.Unmarshal(message.Value, &ping); err != nil {
			log.Println(op, err)
		}

		if err := h.Consumer.Repo.Post(ping); err != nil {
			log.Println(op, err)
			continue
		}

		session.MarkMessage(message, "")
	}

	return nil
}

func NewKafkaConsumer(broker string, groupID string, topics []string, consumer *Consumer) {
	const op = "repository.kafka.NewKafkaConsumer"
	brokers := []string{broker}
	config := sarama.NewConfig()
	config.Version = sarama.V2_8_0_0
	config.Consumer.Return.Errors = true

	group, err := sarama.NewConsumerGroup(brokers, groupID, config)
	if err != nil {
		log.Fatal(op, err)
	}
	defer group.Close()

	handler := &ConsumerGroupHandler{Consumer: consumer}

	ctx := context.Background()
	for {
		if err := group.Consume(ctx, topics, handler); err != nil {
			log.Fatal(op, err)
		}
		if ctx.Err() != nil {
			return
		}
	}
}
