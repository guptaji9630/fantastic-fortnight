#!/bin/bash

# Navigate to the project root directory
cd "$(dirname "$0")/.."

# Build the Go application
echo "Building the Go application..."
go build -o bin/golang-logging-service ./cmd/server/main.go

# Check if the build was successful
if [ $? -eq 0 ]; then
    echo "Build completed successfully."
else
    echo "Build failed."
    exit 1
fi

# Run tests
echo "Running tests..."
go test ./...

# Check if tests passed
if [ $? -eq 0 ]; then
    echo "All tests passed."
else
    echo "Tests failed."
    exit 1
fi

# Notify user of completion
echo "Build and test process completed."