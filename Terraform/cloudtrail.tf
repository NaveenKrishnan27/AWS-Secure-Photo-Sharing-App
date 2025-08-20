# Defines the CloudTrail trail for the Secure Photo Sharing app
# - Captures all management and data events for the uploads S3 bucket
# - Logs are stored in the logs S3 bucket
# - Multi-region trail enabled with global service events included
# - Log file validation is enabled to ensure integrity
# - Uses a KMS key for encrypting CloudTrail logs
# - Depends on the logs bucket policy to ensure proper permissions before creation
# - Tags applied for easier identification and management


resource "aws_cloudtrail" "photo_app_trail" {
  name                          = "photo-app-cloudtrail"
  s3_bucket_name                = aws_s3_bucket.logs.id
  include_global_service_events = true
  enable_logging                = true
  is_multi_region_trail        = true
  enable_log_file_validation   = true

  kms_key_id = "arn:aws:kms:us-east-1:<account id>:key/<Key ID>"

  depends_on = [
    aws_s3_bucket_policy.logs_policy
  ] # this ensures bucket policy exists before trail is created 

  event_selector {
    read_write_type           = "All"
    include_management_events = true

    data_resource {
      type   = "AWS::S3::Object"
      values = [
        "${aws_s3_bucket.uploads.arn}/"
      ]
    }
  }

  tags = {
    App  = "Secure Photo Sharing"
    Name = "CloudTrail Logging"
  }
}
