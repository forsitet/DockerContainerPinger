FROM golang:1.21-alpine AS builder
WORKDIR /app
COPY . .
RUN go build -o pinger ./cmd/main.go  # Путь к main.go должен быть верным

FROM alpine:latest
WORKDIR /app
COPY --from=builder /app/pinger .
CMD ["./pinger"]