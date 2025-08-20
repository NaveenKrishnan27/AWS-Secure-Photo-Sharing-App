# Empties all S3 buckets before teardown.
# Destroys the Secure Photo Sharing App infrastructure with Terraform.


#!/bin/bash
echo "Running cleanup script first "
python empty_s3_buckets.py

echo "Destroying infra with Terraform "
terraform destroy -auto-approve
echo "✅ Destroy complete!"