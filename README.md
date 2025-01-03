# GitHub Action: S3 Build Artifact Downloader

This GitHub Action allows you to download build artifacts from an AWS S3 bucket and extract them. It's a simple way to retrieve your build artifacts stored on S3 and make them available in your workflow.

## Inputs

| **Input**              | **Description**                                                              | **Required** | **Default** |
|------------------------|------------------------------------------------------------------------------|--------------|-------------|
| `aws_access_key_id`     | The AWS Access Key ID for authentication.                                    | ✅            | N/A         |
| `aws_secret_access_key` | The AWS Secret Access Key for authentication.                                | ✅            | N/A         |
| `aws_region`            | The AWS region where your S3 bucket is located.                              | ✅            | N/A         |
| `s3_bucket_name`        | The name of the S3 bucket to down the build artifact from.                    | ✅            | N/A         |
| `project_name`          | The name of your project (used for organizing the artifact).                 | ✅            | N/A         |
| `zip_name`              | The name of the zip file to download and extract.(will attach to project_name )                                | ✅            | N/A         |

## Example Usage

Here’s how you can use this action in your GitHub workflow:

```yaml
name: Demo Workflow
on:
  push:
    branches:
      - staging
  workflow_dispatch:

env:
  AWS_REGION: ap-south-1
  PROJECT_NAME: Your-Project-Name
  S3_BUCKET_NAME: Your-Bucket-Name

jobs:
  download-artifact:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Code
        uses: actions/checkout@v4

      - name: Download Build Artifact from S3
        uses: anilrajrimal1/s3-build-artifact-downloader@v1.2
        with:
          aws_access_key_id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws_secret_access_key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws_region: ${{ env.AWS_REGION }}
          s3_bucket_name: ${{ env.S3_BUCKET_NAME }}
          project_name: ${{ env.PROJECT_NAME }}
          zip_name: ${{ github.ref_name }}-${{ github.run_id }}-${{ github.run_number }}.zip
```
## How it Works
This action will download the specified ZIP file from your S3 bucket and extract its contents to the `dist` directory in your repository. You can customize the zip-name according to your build naming conventions.
- The action uses `boto3` to interact with `AWS S3`.
- The specified ZIP file is downloaded from the S3 bucket and saved locally.
- The file is then extracted to the dist directory.

## Inputs in Detail

1. `aws_access_key_id`: AWS Access Key ID to authenticate the S3 operations.
2. `aws_secret_access_key`: AWS Secret Access Key to authenticate the S3 operations.
3. `aws_region`: The AWS region where the S3 bucket is located (e.g., ap-south-1).
4. `s3_bucket_name`: The name of the S3 bucket where the build artifact is stored.
5. `project_name`: The project name or the identifier of the artifact you want to download.
6. `zip_name`: The exact name of the ZIP file stored in S3.

## Usage

1. Add the action to your workflow YAML file as shown in the example above.
2. Ensure the necessary AWS credentials are stored in the GitHub repository secrets:
   - `AWS_ACCESS_KEY_ID`
   - `AWS_SECRET_ACCESS_KEY`
3. Run the workflow, and the action will download the build artifact (ZIP file) from your S3 bucket.

## License
This GitHub Action is licensed under the MIT License.
