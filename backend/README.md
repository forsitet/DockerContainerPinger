# Backend Service

Бэкенд-сервис для системы мониторинга Docker-контейнеров, написанный на Go.

## Описание

Backend-сервис предоставляет REST API для управления и мониторинга Docker-контейнеров. Сервис взаимодействует с Kafka для обработки событий и использует PostgreSQL для хранения данных.

## Технологии

- Go 1.24
- Chi Router для HTTP-маршрутизации
- Sarama для работы с Kafka
- PostgreSQL для хранения данных
- Swagger для документации API
- Cleanenv для конфигурации

## Структура проекта

```
backend/
├── cmd/            # Точка входа в приложение
├── domain/         # Доменные модели и интерфейсы
├── internal/       # Внутренняя реализация
├── usecases/       # Бизнес-логика
├── docs/           # Документация
├── Dockerfile      # Конфигурация Docker
├── go.mod          # Зависимости Go
└── go.sum          # Контрольные суммы зависимостей
```

## Установка и запуск

1. Убедитесь, что у вас установлен Go 1.23 или выше
2. Установите зависимости:

```bash
go mod download
```

3. Создайте файл `.env` с необходимыми переменными окружения:

```env
DB_HOST=bd_ping
DB_PORT=5432
DB_USER=postgres
DB_PASSWORD=12345
DB_NAME=postgres
KAFKA_BROKERS=kafka:9092
```

4. Запустите сервис:

```bash
go run cmd/main.go
```

## API Документация

Swagger документация доступна по адресу: `http://localhost:8080/swagger/index.html`

## Разработка

### Запуск тестов

```bash
go test ./...
```

### Сборка Docker-образа

```bash
docker build -t ping_backend .
```

## Зависимости

Основные зависимости:

- github.com/IBM/sarama - для работы с Kafka
- github.com/go-chi/chi/v5 - HTTP роутер
- github.com/lib/pq - драйвер PostgreSQL
- github.com/swaggo/swag - генерация Swagger документации
- github.com/ilyakaznacheev/cleanenv - управление конфигурацией
