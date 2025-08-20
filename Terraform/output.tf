# Terraform outputs for Secure Photo Sharing App
# - Provides IAM user ARNs and access keys (uploader/viewer)
# - Provides KMS key ID and CloudFront domain
# - Sensitive outputs (access keys) are marked sensitive
# - Used by automation scripts to populate .env and backend configuration

output "kms_key_id" {
  value = aws_kms_key.logs_kms_key.key_id
}

output "photo_uploader_arn" {
  value = aws_iam_user.photo_uploader.arn
}

output "photo_viewer_arn" {
  value = aws_iam_user.photo_viewer.arn
}
output "photo_uploader_access_key_id" {
  value       = aws_iam_access_key.photo_uploader_key.id
  description = "Access Key ID for photo-uploader"
  sensitive   = true
}

output "photo_uploader_secret_access_key" {
  value       = aws_iam_access_key.photo_uploader_key.secret
  description = "Secret Access Key for photo-uploader"
  sensitive   = true
}

output "photo_viewer_access_key_id" {
  value       = aws_iam_access_key.photo_viewer_key.id
  description = "Access Key ID for photo-viewer"
  sensitive   = true
}

output "photo_viewer_secret_access_key" {
  value       = aws_iam_access_key.photo_viewer_key.secret
  description = "Secret Access Key for photo-viewer"
  sensitive   = true
}
output "cloudfront_domain" {
  value = aws_cloudfront_distribution.photo_app_distribution.domain_name
}

