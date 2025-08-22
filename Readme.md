# 🌟 AWS Secure Photo Sharing App 🌟

A fully secure, Terraform-powered photo-sharing app on AWS. Upload, view, and manage images safely using S3, CloudFront, IAM, and KMS — all without exposing your buckets directly!

## Features
- Secure Uploads & Downloads (signed URLs only)
- Private S3 Buckets (encrypted uploads and logs)
- CloudFront Distribution (fast, globally available, HTTPS enforced)
- IAM Access Control (separate uploader and viewer roles)
- CloudTrail Logging (all actions logged, encrypted with KMS)
- Terraform Automation (infrastructure as code for easy deployment)

## Tech Stack
- AWS: S3, CloudFront, IAM, KMS, CloudTrail
- Backend: Python + Flask
- Frontend: HTML + Vanilla JS (Python HTTP server)
- Infrastructure: Terraform
- Automation: Bash scripts (`start.sh`, `deploy.sh`, `destroy.sh`)

## How It Works
1. Frontend on localhost – users choose Upload or View
2. Backend (Flask) – generates signed CloudFront URLs using IAM keys
3. S3 Uploads Bucket – receives encrypted images securely
4. CloudFront – serves signed URLs only, images never public
5. Logs Bucket – CloudTrail logs all activity, encrypted with KMS

## App Flow:

1. `start.sh` deploys infrastructure, generates `.env`, launches backend, and hosts frontend  
2. **Upload a photo** via the frontend — backend generates a pre-signed PUT URL  
3. **View uploaded photos** via the frontend — backend fetches CloudFront signed GET URLs  
4. `destroy.sh` cleans up everything: empties S3 buckets and destroys Terraform infrastructure 

## Important Notes
- CloudFront Key Pair must be created beforehand
- KMS Key for Logs Bucket must be created beforehand and referenced in Terraform

## Summary
This app is **end-to-end secure, fast, and cloud-ready**. It combines AWS best practices with real-world cloud security concepts:
- Pre-signed URLs to avoid public S3 exposure
- IAM roles strictly separate uploader and viewer privileges
- Encrypted logging and full monitoring with CloudTrail & KMS  
- Infrastructure is fully automated with Terraform, making deployment, teardown, and scaling a breeze
- Deploy, test, and destroy in a few commands — fully repeatable and cost-controlled  
