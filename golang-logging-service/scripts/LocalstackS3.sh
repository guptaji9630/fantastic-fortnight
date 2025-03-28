#!/bin/bash

# Wait for LocalStack to be ready
echo "Waiting for LocalStack to be ready..."
until aws --endpoint-url=http://localstack:4566 s3 ls 2>/dev/null; do
  echo "Waiting for LocalStack S3..."
  sleep 2
done

# Create S3 bucket for logs
echo "Creating S3 bucket for logs..."
aws --endpoint-url=http://localstack:4566 s3 mb s3://logs-bucket --region us-east-1

# Set up bucket notification (optional, for advanced integration)
echo "Setting up S3 bucket notification configuration..."
cat > /tmp/notification.json << EOF
{
  "LambdaFunctionConfigurations": [
    {
      "Id": "LogProcessingNotification",
      "LambdaFunctionArn": "arn:aws:lambda:us-east-1:000000000000:function:log-processor",
      "Events": ["s3:ObjectCreated:*"]
    }
  ]
}
EOF

aws --endpoint-url=http://localstack:4566 s3api put-bucket-notification-configuration \
  --bucket logs-bucket \
  --notification-configuration file:///tmp/notification.json

# Create a sample log file to test
echo "Creating a sample log file for testing..."
mkdir -p /tmp/sample_logs
cat > /tmp/sample_logs/sample.log << EOF
{"level":"info","msg":"This is a sample log entry","time":"2025-03-28T12:00:00Z"}
{"level":"warn","msg":"This is a warning log entry","time":"2025-03-28T12:01:00Z"}
{"level":"error","msg":"This is an error log entry","time":"2025-03-28T12:02:00Z"}
EOF

# Upload sample log to S3
echo "Uploading sample log to S3..."
aws --endpoint-url=http://localstack:4566 s3 cp /tmp/sample_logs/sample.log s3://logs-bucket/sample.log

# List objects in bucket to confirm
echo "Listing objects in S3 bucket:"
aws --endpoint-url=http://localstack:4566 s3 ls s3://logs-bucket

echo "LocalStack setup completed successfully!"