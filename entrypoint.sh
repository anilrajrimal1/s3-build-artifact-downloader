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

# Paths and S3 key
ZIP_PATH="./${ZIP_NAME}"
S3_KEY="${PROJECT_NAME}/${PROJECT_NAME}-${ZIP_NAME}"
DIST_DIR="./dist"

# Current UID and GID
CURRENT_UID=$(id -u)
CURRENT_GID=$(id -g)

# Download the zip file from S3
echo "Downloading ${ZIP_NAME} from s3://${S3_BUCKET_NAME}/${S3_KEY}..."
if aws s3 cp "s3://${S3_BUCKET_NAME}/${S3_KEY}" "$ZIP_PATH"; then
  echo "Successfully downloaded ${ZIP_NAME} to ${ZIP_PATH}"
else
  echo "Failed to download ${ZIP_NAME} from S3." >&2
  exit 1
fi

# Change permissions of the downloaded zip file
chmod 644 "$ZIP_PATH"
chown "$CURRENT_UID:$CURRENT_GID" "$ZIP_PATH"

# Create the destination directory
if [[ ! -d "$DIST_DIR" ]]; then
  mkdir -p "$DIST_DIR"
  echo "Created directory $DIST_DIR"
fi

# Extract the zip file
echo "Extracting ${ZIP_NAME} to ${DIST_DIR}..."
if unzip -q "$ZIP_PATH" -d "$DIST_DIR"; then
  echo "Successfully extracted ${ZIP_NAME} to ${DIST_DIR}/"
else
  echo "Failed to extract ${ZIP_NAME}" >&2
  exit 1
fi

# Update permissions for extracted files
echo "Setting ownership and permissions for extracted files..."
find "$DIST_DIR" -type d -exec chmod 755 {} \; -exec chown "$CURRENT_UID:$CURRENT_GID" {} \;
find "$DIST_DIR" -type f -exec chmod 644 {} \; -exec chown "$CURRENT_UID:$CURRENT_GID" {} \;

echo "Process completed successfully!"
