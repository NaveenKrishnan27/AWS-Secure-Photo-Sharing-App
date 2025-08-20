# Creates IAM access keys for photo-uploader and photo-viewer users
# - These keys are used by the backend to generate presigned PUT and GET URLs
# - Keys are stored in Terraform outputs and later injected into the .env file

resource "aws_iam_access_key" "photo_uploader_key" {
  user = aws_iam_user.photo_uploader.name
}

resource "aws_iam_access_key" "photo_viewer_key" {
  user = aws_iam_user.photo_viewer.name
}
