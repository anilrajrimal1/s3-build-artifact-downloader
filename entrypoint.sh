#!/bin/bash

set -e

# Get inputs from environment variables
AWS_ACCESS_KEY_ID="${INPUT_AWS_ACCESS_KEY_ID}"
AWS_SECRET_ACCESS_KEY="${INPUT_AWS_SECRET_ACCESS_KEY}"
AWS_REGION="${INPUT_AWS_REGION}"
S3_BUCKET_NAME="${INPUT_S3_BUCKET_NAME}"
PROJECT_NAME="${INPUT_PROJECT_NAME}"
ZIP_NAME="${INPUT_ZIP_NAME}"

# Ensure all inputs are provided
if [[ -z "$AWS_ACCESS_KEY_ID" || -z "$AWS_SECRET_ACCESS_KEY" || -z "$AWS_REGION" || -z "$S3_BUCKET_NAME" || -z "$PROJECT_NAME" || -z "$ZIP_NAME" ]]; then
    echo "Error: All inputs must be provided"
    exit 1
fi

# Define paths
ZIP_PATH="./${ZIP_NAME}"
S3_KEY="${PROJECT_NAME}/${PROJECT_NAME}-${ZIP_NAME}"

# Download the zip file from S3
echo "Downloading ${ZIP_NAME} from s3://${S3_BUCKET_NAME}/${S3_KEY}..."

export AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY
export AWS_DEFAULT_REGION="$AWS_REGION"

aws s3 cp "s3://${S3_BUCKET_NAME}/${S3_KEY}" "$ZIP_PATH"

if [[ $? -ne 0 ]]; then
    echo "Failed to download file from S3"
    exit 1
fi

echo "Successfully downloaded ${ZIP_NAME} to ${ZIP_PATH}"

# Extract the zip file to the 'dist' directory
echo "Extracting ${ZIP_NAME} to ./dist..."

mkdir -p ./dist
unzip -o "$ZIP_PATH" -d ./dist

if [[ $? -ne 0 ]]; then
    echo "Error during extraction"
    exit 1
fi

echo "Successfully extracted ${ZIP_NAME} to ./dist/"
