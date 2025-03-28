# Golang Logging Service

## Overview
The Golang Logging Service is a simple HTTP server built in Go that implements structured logging with different log levels (INFO, WARN, DEBUG, ERROR). The service is designed to be easily deployable using Docker and Kubernetes, and it integrates with Loki for log monitoring and visualization.

## Features
- Structured logging with multiple log levels
- Docker and Kubernetes deployment configurations
- Log rotation and archiving
- Integration with Loki for log monitoring

## Project Structure
```
golang-logging-service
├── cmd
│   └── server
│       └── main.go
├── internal
│   ├── app
│   │   └── server.go
│   ├── config
│   │   └── config.go
│   └── logger
│       ├── logger.go
│       └── formatter.go
├── pkg
│   └── utils
│       └── utils.go
├── api
│   └── routes.go
├── deployments
│   ├── docker
│   │   ├── Dockerfile
│   │   └── docker-compose.yml
│   └── k8s
│       ├── deployment.yaml
│       └── service.yaml
├── configs
│   ├── app.yaml
│   └── logging.yaml
├── monitoring
│   ├── loki
│   │   ├── loki-config.yaml
│   │   └── promtail-config.yaml
│   └── localstack
│       └── config.json
├── scripts
│   ├── build.sh
│   └── deploy.sh
├── go.mod
├── go.sum
├── Makefile
└── README.md
```

## Getting Started

### Prerequisites
- Go (version 1.16 or higher)
- Docker
- Docker Compose
- Kubernetes (optional, for deployment)

### Installation
1. Clone the repository:
   ```
   git clone https://github.com/guptaji9630/fantastic-fortnight/edit/main/golang-logging-service
   cd golang-logging-service
   ```

2. Build the application:
   ```
   ./scripts/build.sh
   ```

### Running the Application
#### Using Docker
1. Build and run the Docker container:
   ```
   docker-compose up --build
   ```

#### Using Kubernetes
1. Deploy the application to your Kubernetes cluster:
   ```
   kubectl apply -f deployments/k8s/deployment.yaml
   kubectl apply -f deployments/k8s/service.yaml
   ```

### Log Monitoring with Loki
1. Configure Loki and Promtail using the provided configuration files in the `monitoring/loki` directory.
2. Start Loki and Promtail to collect and visualize logs.

## Log Rotation
The application implements log rotation to manage log file sizes and prevent excessive disk usage. Ensure that the log rotation tool is configured correctly in your environment.

## Contributing
Contributions are welcome! Please submit a pull request or open an issue for any enhancements or bug fixes.

## License
This project is licensed under the MIT License. See the LICENSE file for details.
