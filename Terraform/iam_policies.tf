# Defines IAM policies for the Secure Photo Sharing app users
# - photo-uploader: permissions to upload images, manage CORS, and view bucket versioning
# - photo-viewer: permissions to list and read images
# - Policies are attached to the respective IAM users


# ----------------------------
# Policy for photo-uploader
# ----------------------------
data "aws_iam_policy_document" "photo_uploader_policy" {
  statement {
    sid = "S3UploadAccess"
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:GetBucketVersioning"
    ]
    resources = [
      aws_s3_bucket.uploads.arn,
      "${aws_s3_bucket.uploads.arn}/*"
    ]
    effect = "Allow"
  }

  statement {
    actions = [
      "s3:PutBucketCORS",
      "s3:GetBucketCORS"
    ]
    resources = [aws_s3_bucket.uploads.arn]
    effect    = "Allow"
  }
}

resource "aws_iam_policy" "photo_uploader_policy" {
  name   = "photo-uploader-policy"
  policy = data.aws_iam_policy_document.photo_uploader_policy.json
}

resource "aws_iam_user_policy_attachment" "photo_uploader_attach" {
  user       = aws_iam_user.photo_uploader.name
  policy_arn = aws_iam_policy.photo_uploader_policy.arn
}

# ----------------------------
# Policy for photo-viewer
# ----------------------------
data "aws_iam_policy_document" "photo_viewer_policy" {
  statement {
    sid = "AllowListAndRead"
    actions = [
      "s3:ListBucket",
      "s3:GetObject",
      "s3:GetObjectAcl"
    ]
    resources = [
      aws_s3_bucket.uploads.arn,
      "${aws_s3_bucket.uploads.arn}/*"
    ]
    effect = "Allow"
  }
}

resource "aws_iam_policy" "photo_viewer_policy" {
  name   = "photo-viewer-policy"
  policy = data.aws_iam_policy_document.photo_viewer_policy.json
}

resource "aws_iam_user_policy_attachment" "photo_viewer_attach" {
  user       = aws_iam_user.photo_viewer.name
  policy_arn = aws_iam_policy.photo_viewer_policy.arn
}
