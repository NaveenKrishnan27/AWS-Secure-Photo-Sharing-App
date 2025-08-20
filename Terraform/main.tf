# Main Terraform configuration for Secure Photo Sharing App
# - Configures AWS provider and region (us-east-1)
# - Creates S3 buckets:
#    • uploads-bucket: stores user-uploaded photos, with CORS for localhost frontend/backend, SSE-S3 encryption, and blocked public access
#    • logs-bucket: stores logs and monitoring data, with SSE-KMS encryption and blocked public access
# - Includes server-side encryption and public access restrictions for security


# ---------------------- Uploads Bucket Configuration ----------------------

# Create the main bucket to store uploaded photos
resource "aws_s3_bucket" "uploads" {
  bucket = "uploads-bucket"

  tags = {
    Name = "Photo App Uploads"
    App  = "Secure Photo Sharing"
  }
}

# Ensure the uploads bucket has no public access
resource "aws_s3_bucket_public_access_block" "uploads_block" {
  bucket                  = aws_s3_bucket.uploads.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Enable default server-side encryption using AES-256 (SSE-S3)
resource "aws_s3_bucket_server_side_encryption_configuration" "uploads_encryption" {
  bucket = aws_s3_bucket.uploads.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Allow CORS for localhost:8000 (frontend) with GET and PUT methods
resource "aws_s3_bucket_cors_configuration" "uploads_cors" {
  bucket = aws_s3_bucket.uploads.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["PUT", "GET"]
    allowed_origins = ["http://localhost:8000", "http://localhost:5000"]
    expose_headers  = []
    max_age_seconds = 3000
  }
}

# ---------------------- Logs Bucket Configuration ----------------------

# Create the S3 bucket for access logs and app monitoring data
resource "aws_s3_bucket" "logs" {
  bucket = "logs-bucket"

  tags = {
    Name = "Photo App Logs"
    App  = "Secure Photo Sharing"
  }
}

# Block all forms of public access to the logs bucket
resource "aws_s3_bucket_public_access_block" "logs_block" {
  bucket                  = aws_s3_bucket.logs.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Enable server-side encryption using KMS (SSE-KMS)
# Replace the kms_master_key_id with your actual KMS key ARN
resource "aws_s3_bucket_server_side_encryption_configuration" "logs_encryption" {
  bucket = aws_s3_bucket.logs.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = "arn:aws:kms:us-east-1:<Account_ID>:key/<Key>"
    }
  }
}
