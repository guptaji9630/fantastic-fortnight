# Makefile

.PHONY: build run docker-build docker-compose up docker-compose down clean

build:
	go build -o bin/server ./cmd/server/main.go

run: build
	./bin/server

docker-build:
	docker build -t golang-logging-service ./deployments/docker

docker-compose:
	docker-compose -f ./deployments/docker/docker-compose.yml up -d

docker-compose-down:
	docker-compose -f ./deployments/docker/docker-compose.yml down

clean:
	go clean
	rm -rf bin/