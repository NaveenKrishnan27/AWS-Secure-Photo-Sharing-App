# Defines the CloudFront distribution for the Secure Photo Sharing app
# - Serves content from the uploads S3 bucket via an Origin Access Control (OAC)
# - Uses signed URLs via a trusted key group for secure access
# - Default cache behavior uses AWS-managed CachingOptimized policy
# - Redirects HTTP to HTTPS and enables compression
# - Viewer certificate is default CloudFront SSL (TLSv1.2_2021)
# - No geo-restrictions applied; price class covers all regions

resource "aws_cloudfront_distribution" "photo_app_distribution" {
  origin {
    domain_name = "photo-app-uploads-bucket-dev.s3.us-east-1.amazonaws.com"
    origin_id   = "photo-app-origin-dev"

    origin_access_control_id = "<OAC ID>" # Your OAC

    connection_attempts = 3
    connection_timeout  = 10
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Secure Photo Sharing App CloudFront"
  default_root_object = ""

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "photo-app-origin-dev"

    viewer_protocol_policy = "redirect-to-https"

    compress               = true
    cache_policy_id        = "658327ea-f89d-4fab-a63d-7e88639e58f6" # CachingOptimized (AWS managed)

    trusted_key_groups = ["<Keygroup>"] #  Corrected to argument
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
  cloudfront_default_certificate = true
  minimum_protocol_version       = "TLSv1.2_2021" #  Upgrade from TLSv1
  ssl_support_method             = "vip"
  }

  price_class = "PriceClass_All"
}
