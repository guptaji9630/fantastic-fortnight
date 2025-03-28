#!/bin/bash

# Wait for Grafana to be ready
echo "Waiting for Grafana to be ready..."
until curl -s http://grafana:3000/api/health | grep -q "ok"; do
  echo "Waiting for Grafana API..."
  sleep 2
done

# Add Loki data source
echo "Adding Loki data source..."
curl -s -X POST -H "Content-Type: application/json" -d '{
  "name": "Loki",
  "type": "loki",
  "url": "http://loki:3100",
  "access": "proxy",
  "basicAuth": false
}' http://admin:admin@grafana:3000/api/datasources

# Create a dashboard for logs
echo "Creating log dashboard..."
curl -s -X POST -H "Content-Type: application/json" -d '{
  "dashboard": {
    "id": null,
    "title": "Log Monitoring Dashboard",
    "tags": ["logs", "golang", "s3"],
    "timezone": "browser",
    "schemaVersion": 16,
    "version": 0,
    "refresh": "10s",
    "panels": [
      {
        "title": "All Logs",
        "type": "logs",
        "datasource": "Loki",
        "targets": [
          {
            "expr": "{job=~\".*\"}",
            "refId": "A"
          }
        ],
        "gridPos": {
          "h": 8,
          "w": 24,
          "x": 0,
          "y": 0
        }
      },
      {
        "title": "Error Logs",
        "type": "logs",
        "datasource": "Loki",
        "targets": [
          {
            "expr": "{job=~\".*\"} |= \"level=error\"",
            "refId": "A"
          }
        ],
        "gridPos": {
          "h": 8,
          "w": 12,
          "x": 0,
          "y": 8
        }
      },
      {
        "title": "Warning Logs",
        "type": "logs",
        "datasource": "Loki",
        "targets": [
          {
            "expr": "{job=~\".*\"} |= \"level=warn\"",
            "refId": "A"
          }
        ],
        "gridPos": {
          "h": 8,
          "w": 12,
          "x": 12,
          "y": 8
        }
      },
      {
        "title": "S3 Archived Logs",
        "type": "logs",
        "datasource": "Loki",
        "targets": [
          {
            "expr": "{source=\"s3\"}",
            "refId": "A"
          }
        ],
        "gridPos": {
          "h": 8,
          "w": 24,
          "x": 0,
          "y": 16
        }
      }
    ]
  },
  "overwrite": false
}' http://admin:admin@grafana:3000/api/dashboards/db

echo "Grafana setup completed successfully!"