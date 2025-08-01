# Stage 1 - Builder
FROM golang:1.21 AS builder

WORKDIR /app
COPY . .
RUN go mod tidy
RUN go mod download

RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o simple-golang-api .

# Stage 2 - Final (minimal RHEL-based)
FROM registry.access.redhat.com/ubi8/ubi-minimal:8.9

WORKDIR /app
COPY --from=builder /app/simple-golang-api .

EXPOSE 9000
ENTRYPOINT ["/app/simple-golang-api"]
