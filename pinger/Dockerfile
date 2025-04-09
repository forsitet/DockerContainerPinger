FROM golang:1.24

WORKDIR /app

COPY . .

RUN go mod tidy
RUN  go build -o pinger ./cmd/main.go

CMD [ "/app/backend", "--config=./cmd/app/config/config.yml" ]