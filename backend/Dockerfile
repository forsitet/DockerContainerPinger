FROM golang:1.24

WORKDIR /app

COPY . .

RUN go mod tidy
RUN  go build -o backend ./cmd/app/main.go

CMD [ "/app/backend", "--config=/app/cmd/app/config.yml" ]
