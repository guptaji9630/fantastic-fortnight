#!/bin/bash

# Set variables
LOG_DIR="/var/log/golang-logging-service"
S3_BUCKET="logs-bucket"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
REGION="us-east-1"
ENDPOINT_URL="http://localstack:4566"

# Ensure LocalStack is ready
echo "Checking LocalStack availability..."
until aws --endpoint-url=$ENDPOINT_URL s3 ls --region $REGION 2>/dev/null; do
  echo "Waiting for LocalStack to be ready..."
  sleep 2
done

# Create the S3 bucket if it doesn't exist
aws --endpoint-url=$ENDPOINT_URL s3 mb s3://$S3_BUCKET --region $REGION 2>/dev/null || true
echo "Using S3 bucket: $S3_BUCKET"

# Compress logs that need to be rotated (older than 1 day)
find $LOG_DIR -name "*.log" -type f -mtime +1 | while read -r log_file; do
  # Get just the filename without the path
  filename=$(basename "$log_file")
  
  echo "Processing log file: $filename"
  
  # Make a copy of the log file to avoid issues with active logging
  cp "$log_file" "${log_file}.rotating"
  
  # Compress the copy
  gzip -c "${log_file}.rotating" > "${log_file}.gz"
  
  # Upload to S3
  s3_key="${TIMESTAMP}-${filename}.gz"
  echo "Uploading to S3 as: $s3_key"
  
  aws --endpoint-url=$ENDPOINT_URL s3 cp "${log_file}.gz" "s3://$S3_BUCKET/$s3_key" --region $REGION
  
  if [ $? -eq 0 ]; then
    echo "Successfully uploaded to S3: s3://$S3_BUCKET/$s3_key"
    
    # Truncate the original log file
    > "$log_file"
    echo "Truncated original log file: $log_file"
    
    # Clean up temporary files
    rm "${log_file}.rotating" "${log_file}.gz"
  else
    echo "Failed to upload to S3. Keeping original log file intact."
    rm "${log_file}.rotating" "${log_file}.gz"
  fi
done
# Fix the log-rotate.sh file name (remove space)
mv "/home/gg_goku/Wecridit/golang-logging-service/scripts/ log-rotate.sh" "/home/gg_goku/Wecridit/golang-logging-service/scripts/log-rotate.sh"

# Fix the comment style in all script files
for script in /home/gg_goku/Wecridit/golang-logging-service/scripts/*.sh; do
  sed -i 's/^\/\/ filepath:/# filepath:/g' $script
done

# Fix the comment style in Docker and other config files
sed -i 's/^\/\/ filepath:/# filepath:/g' /home/gg_goku/Wecridit/golang-logging-service/deployments/docker/Dockerfile
sed -i 's/^\/\/ filepath:/# filepath:/g' /home/gg_goku/Wecridit/golang-logging-service/deployments/docker/docker-compose.yml
sed -i 's/^\/\/ filepath:/# filepath:/g' /home/gg_goku/Wecridit/golang-logging-service/monitoring/localstack/config.json

echo "Log rotation completed at $(date)"