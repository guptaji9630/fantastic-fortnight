FROM golang:1.18-alpine AS builder

WORKDIR /app

# Copy go mod and sum files
COPY go.mod go.sum ./

# Download all dependencies
RUN go mod download

# Copy the source from the current directory to the Working Directory inside the container
COPY . .

# Build the Go app
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o main ./cmd/server/main.go

# Start a new stage from scratch
FROM alpine:latest

WORKDIR /root/

# Install necessary packages
RUN apk --no-cache add ca-certificates tzdata

# Set timezone
ENV TZ=UTC

# Create log directory
RUN mkdir -p /var/log/golang-logging-service

# Copy the Pre-built binary file from the previous stage
COPY --from=builder /app/main .
COPY --from=builder /app/configs ./configs

# Expose port 8080 to the outside world
EXPOSE 8080

# Command to run the executable
CMD ["./main"]