# GitHub Action: S3 Build Artifact Downloader

This GitHub Action allows you to download build artifacts from an AWS S3 bucket and extract them into a specified directory (e.g., `dist`). It's a simple way to retrieve your build artifacts stored on S3 and make them available in your workflow.

## Inputs

| **Input**              | **Description**                                             | **Required** | **Default** |
|------------------------|-------------------------------------------------------------|--------------|-------------|
| `aws-access-key-id`     | The AWS Access Key ID for authentication                    | Yes          | N/A         |
| `aws-secret-access-key` | The AWS Secret Access Key for authentication                | Yes          | N/A         |
| `aws-region`            | The AWS region where the S3 bucket is located               | Yes          | N/A         |
| `s3-bucket-name`        | The name of the S3 bucket where the artifact is stored      | Yes          | N/A         |
| `project-name`          | The name of the project or artifact to be downloaded        | Yes          | N/A         |
| `zip-name`              | The name of the zip file stored in the S3 bucket            | Yes          | N/A         |

## Example Usage

Here’s how you can use this action in your GitHub workflow:

```yaml
      - name: Download Build Artifact from S3
        uses: anilrajrimal1/s3-build-artifact-downloader@v1
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: ${{ secrets.AWS_REGION }}
          s3-bucket-name: ${{ secrets.S3_BUCKET_NAME }}
          project-name: my-project
          zip-name: ${{ github.run_id }}-${{ github.run_attempt }}.zip
```
## How it Works
This action will download the specified ZIP file from your S3 bucket and extract its contents to the dist directory in your repository. You can customize the zip-name according to your build naming conventions.
    - The action uses `boto3` to interact with `AWS S3`.
    - The specified ZIP file is downloaded from the S3 bucket and saved locally.
    - The file is then extracted to the dist directory.

## Inputs in Detail

1. `aws-access-key-id`: AWS Access Key ID to authenticate the S3 operations.
2. `aws-secret-access-key`: AWS Secret Access Key to authenticate the S3 operations.
3. `aws-region`: The AWS region where the S3 bucket is located (e.g., us-east-1).
4. `s3-bucket-name`: The name of the S3 bucket where the build artifact is stored.
5. `project-name`: The project name or the identifier of the artifact you want to download.
6. `zip-name`: The exact name of the ZIP file stored in S3.

## Usage

1. Add the action to your workflow YAML file as shown in the example above.
2. Ensure the necessary AWS credentials are stored in the GitHub repository secrets:
   - `AWS_ACCESS_KEY_ID`
   - `AWS_SECRET_ACCESS_KEY`
   - `AWS_REGION`
   - `S3_BUCKET_NAME`
3. Run the workflow, and the action will download the build artifact (ZIP file) from your S3 bucket.

## License
This GitHub Action is licensed under the MIT License.