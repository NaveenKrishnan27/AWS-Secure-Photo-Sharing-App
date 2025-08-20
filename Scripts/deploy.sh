# Deploy Terraform infra and auto-approve
# Generate fresh .env with uploader/viewer AWS credentials
# Update generate_signed_url.py with latest CloudFront domain


#!/bin/bash
cd "$(dirname "$0")"
echo "Rebuilding Secure Photo App infra..."
terraform apply -auto-approve

echo "Infra deployed!"

echo "Generating .env from Terraform outputs..."

# Generate .env with both uploader and viewer creds
echo "UPLOADER_ACCESS_KEY_ID=$(terraform output -raw photo_uploader_access_key_id)" > .env
echo "UPLOADER_SECRET_ACCESS_KEY=$(terraform output -raw photo_uploader_secret_access_key)" >> .env
echo "VIEWER_ACCESS_KEY_ID=$(terraform output -raw photo_viewer_access_key_id)" >> .env
echo "VIEWER_SECRET_ACCESS_KEY=$(terraform output -raw photo_viewer_secret_access_key)" >> .env

echo ".env generated with fresh AWS creds!"

cf_domain=$(terraform output -raw cloudfront_domain)

# Debug print
echo " Updating CloudFront domain in generate_signed_url.py: $cf_domain"

# Use temp file to safely replace
awk -v domain="$cf_domain" '{gsub("<CLOUDFRONT_DOMAIN_PLACEHOLDER>", domain); print}' generate_signed_url.py > temp_generate_signed_url.py && mv temp_generate_signed_url.py generate_signed_url.py

echo "CloudFront domain updated in generate_signed_url.py (Git Bash-safe)"
