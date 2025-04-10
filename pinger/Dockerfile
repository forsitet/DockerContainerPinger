FROM golang:1.24

WORKDIR /app
COPY . .
RUN go mod tidy
ENTRYPOINT [ "/ls" ]
RUN go build -o pinger ./cmd/main.go

CMD ["./pinger"]