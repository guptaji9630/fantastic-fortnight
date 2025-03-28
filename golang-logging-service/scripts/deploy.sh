#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Build the Docker image
echo "Building the Docker image..."
docker-compose -f deployments/docker/docker-compose.yml build

# Deploy the application using Docker Compose
echo "Deploying the application..."
docker-compose -f deployments/docker/docker-compose.yml up -d

# Check if the deployment was successful
if [ $? -eq 0 ]; then
    echo "Deployment successful!"
else
    echo "Deployment failed!"
    exit 1
fi

# Optional: Archive logs with log rotation (using logrotate)
echo "Setting up log rotation..."
logrotate -f /etc/logrotate.d/myapp

# Optional: Start Loki and Promtail for log monitoring
echo "Starting Loki and Promtail..."
docker-compose -f monitoring/loki/docker-compose.yml up -d

echo "Deployment and log monitoring setup completed."