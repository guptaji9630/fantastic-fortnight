#!/bin/bash

# Set variables
S3_BUCKET="logs-bucket"
ENDPOINT_URL="http://localstack:4566"
REGION="us-east-1"
TEMP_DIR="/tmp/s3logs"
LOKI_URL="http://loki:3100/loki/api/v1/push"

# Create temp directory if it doesn't exist
mkdir -p $TEMP_DIR

# List objects in the S3 bucket
echo "Fetching logs from S3 bucket: $S3_BUCKET"
aws --endpoint-url=$ENDPOINT_URL s3 ls s3://$S3_BUCKET --region $REGION | while read -r line; do
  # Extract the filename
  filename=$(echo $line | awk '{print $4}')
  
  if [[ -z "$filename" ]]; then
    continue
  fi
  
  echo "Processing file: $filename"
  
  # Download the file from S3
  aws --endpoint-url=$ENDPOINT_URL s3 cp "s3://$S3_BUCKET/$filename" "$TEMP_DIR/$filename" --region $REGION
  
  # If it's a gzipped file, extract it
  if [[ "$filename" == *.gz ]]; then
    gunzip -c "$TEMP_DIR/$filename" > "$TEMP_DIR/${filename%.gz}"
    log_file="$TEMP_DIR/${filename%.gz}"
  else
    log_file="$TEMP_DIR/$filename"
  fi
  
  # Send the logs to Loki
  # For each line in the log file
  while IFS= read -r log_line; do
    # Skip empty lines
    if [[ -z "$log_line" ]]; then
      continue
    fi
    
    # Prepare JSON payload for Loki
    timestamp=$(date +%s%N)
    payload=$(cat <<EOF
{
  "streams": [
    {
      "stream": {
        "source": "s3",
        "job": "s3logs",
        "filename": "$filename"
      },
      "values": [
        ["$timestamp", "$log_line"]
      ]
    }
  ]
}
EOF
)
    
    # Send to Loki
    curl -v -H "Content-Type: application/json" -X POST "$LOKI_URL" -d "$payload"
    
  done < "$log_file"
  
  # Clean up
  rm "$log_file"
  if [[ "$filename" == *.gz ]]; then
    rm "$TEMP_DIR/$filename"
  fi
  
  echo "Successfully processed $filename"
done

echo "S3 to Loki sync completed at $(date)"