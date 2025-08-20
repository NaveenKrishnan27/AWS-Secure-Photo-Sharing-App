# Script to empty all objects from the project's S3 buckets
# Useful for cleanup before destroying infrastructure or redeploying
# Deletes all objects from given S3 bucket
# Supports both versioned and non-versioned buckets
# Use with caution: permanently deletes all objects

import boto3
from botocore.exceptions import ClientError

def delete_all_objects(bucket_name):
    session = boto3.Session(profile_name='<I used an admin profile>')
    s3 = session.client('s3')

    try:
        s3.head_bucket(Bucket=bucket_name)
    except ClientError as e:
        if e.response['Error']['Code'] == '404':
            print(f" Bucket {bucket_name} does not exist. Skipping.")
            return
        else:
            print(f" Error checking bucket {bucket_name}: {e}")
            return

    versioning = s3.get_bucket_versioning(Bucket=bucket_name)
    is_versioned = versioning.get('Status') == 'Enabled'

    if is_versioned:
        paginator = s3.get_paginator('list_object_versions')
        print(f"Emptying versioned bucket: {bucket_name}")
        for page in paginator.paginate(Bucket=bucket_name):
            versions = page.get('Versions', []) + page.get('DeleteMarkers', [])
            for obj in versions:
                s3.delete_object(Bucket=bucket_name, Key=obj['Key'], VersionId=obj['VersionId'])
    else:
        print(f"Emptying non-versioned bucket: {bucket_name}")
        paginator = s3.get_paginator('list_objects_v2')
        for page in paginator.paginate(Bucket=bucket_name):
            for obj in page.get('Contents', []):
                s3.delete_object(Bucket=bucket_name, Key=obj['Key'])

if __name__ == "__main__":
    delete_all_objects('uploads-bucket')
    delete_all_objects('logs-bucket')
