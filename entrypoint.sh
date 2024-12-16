#!/bin/bash

# Ensure script exits on error
set -e

# Get inputs from environment variables
AWS_ACCESS_KEY_ID="${INPUT_AWS_ACCESS_KEY_ID}"
AWS_SECRET_ACCESS_KEY="${INPUT_AWS_SECRET_ACCESS_KEY}"
AWS_REGION="${INPUT_AWS_REGION}"
S3_BUCKET_NAME="${INPUT_S3_BUCKET_NAME}"
PROJECT_NAME="${INPUT_PROJECT_NAME}"
ZIP_NAME="${INPUT_ZIP_NAME}"

# Validate required inputs
if [[ -z "$AWS_ACCESS_KEY_ID" || -z "$AWS_SECRET_ACCESS_KEY" || -z "$AWS_REGION" || -z "$S3_BUCKET_NAME" || -z "$PROJECT_NAME" || -z "$ZIP_NAME" ]]; then
  echo "All inputs must be provided." >&2
  exit 1
fi

# Set AWS credentials for AWS CLI
export AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY
export AWS_DEFAULT_REGION="$AWS_REGION"

# Paths
ZIP_PATH="./${ZIP_NAME}"
S3_KEY="${PROJECT_NAME}/${PROJECT_NAME}-${ZIP_NAME}"
DIST_DIR="./dist"

# Cleanup
if [[ -d "$DIST_DIR" ]]; then
  echo "Cleaning up previous files in ${DIST_DIR}..."
  rm -rf "$DIST_DIR"  # Remove the dist directory
fi

# Download the zip file from S3
echo "Downloading ${ZIP_NAME} from s3://${S3_BUCKET_NAME}/${S3_KEY}..."
aws s3 cp "s3://${S3_BUCKET_NAME}/${S3_KEY}" "$ZIP_PATH"

# Create target directory
mkdir -p "$DIST_DIR"

# Extract the zip file
echo "Extracting ${ZIP_NAME} to ${DIST_DIR}..."
unzip -q "$ZIP_PATH" -d "$DIST_DIR"

echo "Setting permissions for extracted files..."

chown -R appuser:appuser "$DIST_DIR"

# Set directory permissions
find "$DIST_DIR" -type d -exec chmod 755 {} \;

# Set file permissions
find "$DIST_DIR" -type f -exec chmod 644 {} \;

echo "Process completed successfully!"
