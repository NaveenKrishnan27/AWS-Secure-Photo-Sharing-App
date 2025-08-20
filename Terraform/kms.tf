# Creates a KMS key for encrypting CloudTrail logs in the logs bucket
# - Key rotation enabled
# - Deletion window set to 7 days


resource "aws_kms_key" "logs_kms_key" {
  description             = "KMS key for encrypting logs in the logs bucket"
  deletion_window_in_days = 7
  enable_key_rotation     = true
}
