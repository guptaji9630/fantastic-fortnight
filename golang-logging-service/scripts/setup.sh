#!/bin/bash

echo "=== Setting up Golang Logging Service with LocalStack S3 Integration ==="

# Build and start all services
echo "Starting all services..."
docker-compose -f deployments/docker/docker-compose.yml up -d

# Wait for all services to be ready
echo "Waiting for services to be ready..."
sleep 10

# Setup LocalStack S3
echo "Setting up LocalStack..."
docker exec localstack /scripts/setup-localstack.sh

# Initialize Grafana dashboards
echo "Setting up Grafana dashboards..."
docker exec grafana /scripts/setup-grafana.sh

# Generate some test logs
echo "Generating test logs..."
for i in {1..10}; do
  curl -s http://localhost:8080/info > /dev/null
  curl -s http://localhost:8080/warn > /dev/null
  curl -s http://localhost:8080/debug > /dev/null
  curl -s http://localhost:8080/error > /dev/null
  sleep 1
done

# Trigger a manual log rotation to see it in action
echo "Triggering a manual log rotation..."
docker exec log-rotator /scripts/log-rotate.sh

# Sync logs from S3 to Loki
echo "Syncing S3 logs to Loki..."
docker exec s3-to-loki-sync /scripts/s3-to-loki.sh

echo "=== Setup completed successfully! ==="
echo ""
echo "You can access:"
echo "- The Golang service at: http://localhost:8080"
echo "- Grafana dashboards at: http://localhost:3000"
echo "- Loki API at: http://localhost:3100"
echo "- LocalStack S3 (via AWS CLI): aws --endpoint-url=http://localhost:4566 s3 ls"
echo ""
echo "To generate more logs, use:"
echo "curl http://localhost:8080/info"
echo "curl http://localhost:8080/warn"
echo "curl http://localhost:8080/debug"
echo "curl http://localhost:8080/error"