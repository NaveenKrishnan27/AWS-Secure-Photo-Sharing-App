Secure Photo Sharing App

A cloud-secure, Terraform-powered photo sharing app that keeps your images safe while making uploads and viewing seamless. Every action is logged, encrypted, and access-controlled.

⚡ Features

Secure Uploads: Only authorized users can upload images using signed PUT URLs.

Secure Viewing: CloudFront signed GET URLs prevent direct S3 access.

Private S3 Buckets: Configured with CORS for localhost and server-side encryption.

CloudTrail + KMS: Logs all actions, KMS-encrypted for integrity.

IAM Role Separation: Dedicated users for uploading and viewing.

Terraform-Powered: Infrastructure fully reproducible and automated.

Automation-Ready: Backend credentials and CloudFront domain updates handled automatically.

🛠️ Tech Stack

Frontend: HTML, CSS, JS

Backend: Flask + Python

AWS Services: S3, CloudFront, IAM, CloudTrail, KMS

Infrastructure as Code: Terraform

⚡ Key Notes

CloudFront key pair must be created beforehand for signed GET URLs.

KMS key for logs bucket must be created and replaced in Terraform before deployment.

🚀 Flow
Frontend (Browser)
       |
       | Upload / View Request
       v
   Flask Backend
   - Generates signed PUT/GET URLs
   - Lists S3 files
       |
       v
  AWS S3 Buckets
  uploads-bucket      <- Private image storage
  logs-bucket         <- KMS-encrypted CloudTrail logs
       ^
       |
   CloudFront
   - Delivers images securely
   - Uses pre-created key pair


Deploy everything with Terraform in minutes — credentials generated, CloudFront updated, backend running — all ready to go live.