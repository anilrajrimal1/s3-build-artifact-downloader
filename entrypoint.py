import os
import zipfile
import boto3
from botocore.exceptions import NoCredentialsError, ClientError

# Get inputs from environment variables
aws_access_key_id = os.getenv('INPUT_AWS_ACCESS_KEY_ID')
aws_secret_access_key = os.getenv('INPUT_AWS_SECRET_ACCESS_KEY')
aws_region = os.getenv('INPUT_AWS_REGION')
s3_bucket_name = os.getenv('INPUT_S3_BUCKET_NAME')
project_name = os.getenv('INPUT_PROJECT_NAME')
zip_name = os.getenv('INPUT_ZIP_NAME')

# Ensure all inputs are provided
if not all([aws_access_key_id, aws_secret_access_key, aws_region, s3_bucket_name, project_name, zip_name]):
    raise ValueError("All inputs must be provided")

current_uid = os.getuid()
current_gid = os.getgid()

# Download the zip file from S3
s3_client = boto3.client(
    's3',
    aws_access_key_id=aws_access_key_id,
    aws_secret_access_key=aws_secret_access_key,
    region_name=aws_region
)

zip_path = f'./{zip_name}'
s3_key = f'{project_name}/{project_name}-{zip_name}'

try:
    print(f'Downloading {zip_name} from s3://{s3_bucket_name}/{s3_key}...')
    s3_client.download_file(s3_bucket_name, s3_key, zip_path)
    print(f'Successfully downloaded {zip_name} to {zip_path}')

    os.chmod(zip_path, 0o644)
    os.chown(zip_path, current_uid, current_gid)

except NoCredentialsError:
    print("AWS credentials not available.")
    exit(1)
except ClientError as e:
    print(f"Failed to download file: {e}")
    exit(1)

dist_dir = './dist'

if not os.path.exists(dist_dir):
    os.makedirs(dist_dir)

try:
    print(f'Extracting {zip_name} to ./dist...')
    with zipfile.ZipFile(zip_path, 'r') as zip_ref:
        zip_ref.extractall(dist_dir)

    for root, dirs, files in os.walk(dist_dir):
        for file in files:
            file_path = os.path.join(root, file)
            os.chmod(file_path, 0o755)
            os.chown(file_path, current_uid, current_gid)

    print(f'Successfully extracted {zip_name} to ./dist/')
except Exception as e:
    print(f"Error during extraction: {e}")
    exit(1)
