FROM golang:1.24

WORKDIR /app

COPY . .

RUN go mod tidy
RUN  go build -o pinger ./cmd/app/main.go

CMD [ "/app/pinger", "--config=./cmd/app/config/config.yml"]
