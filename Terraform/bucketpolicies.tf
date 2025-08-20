# Defines S3 bucket policies for the Secure Photo Sharing app
# - Grants CloudFront OAC access to the uploads bucket (read + write)
# - Grants CloudTrail access to write and verify logs in the logs bucket


# ---------------- Uploads Bucket Policy for CloudFront OAC ----------------
data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "uploads_bucket_policy" {
  statement {
    sid = "AllowCloudFrontAccess"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    actions = [
      "s3:GetObject",
      "s3:PutObject"
    ]

    resources = [
      "${aws_s3_bucket.uploads.arn}/*"
    ]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.photo_app_distribution.arn]
    }
  }
}

resource "aws_s3_bucket_policy" "uploads_policy" {
  bucket = aws_s3_bucket.uploads.id
  policy = data.aws_iam_policy_document.uploads_bucket_policy.json
}

# ---------------- Logs Bucket Policy for CloudTrail ----------------
data "aws_iam_policy_document" "logs_bucket_policy" {
  # CloudTrail must be allowed to put logs into a specific prefix
  statement {
    sid     = "AWSCloudTrailWrite"
    effect  = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions = [
      "s3:PutObject"
    ]

    resources = [
      "${aws_s3_bucket.logs.arn}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"
    ]

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }

  # Allow CloudTrail to get the bucket ACL (required for verification)
  statement {
    sid     = "AWSCloudTrailGetAcl"
    effect  = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions = [
      "s3:GetBucketAcl"
    ]

    resources = [
      aws_s3_bucket.logs.arn
    ]
  }
}

resource "aws_s3_bucket_policy" "logs_policy" {
  bucket = aws_s3_bucket.logs.id
  policy = data.aws_iam_policy_document.logs_bucket_policy.json
}
