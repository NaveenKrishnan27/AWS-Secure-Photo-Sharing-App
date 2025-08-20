# Creates IAM users for the Secure Photo Sharing app
# - photo-uploader: user for generating signed PUT URLs for uploads
# - photo-viewer: user for generating signed GET URLs for viewing images


resource "aws_iam_user" "photo_uploader" {
  name = "photo-uploader"
}

resource "aws_iam_user" "photo_viewer" {
  name = "photo-viewer"
}
