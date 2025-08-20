# Script to generate .env files for uploader, viewer, and root credentials
# Populates environment variables used by the backend and automation scripts
# Generates .env file with IAM credentials for uploader/viewer
# Fetches values directly from Terraform outputs
# Overwrites previous .env, so old credentials are replaced


import subprocess

def get_tf_output(name):
    result = subprocess.run(
        ['terraform', 'output', '-json', name],
        capture_output=True, text=True
    )
    return result.stdout.strip().strip('"')

uploader_key = get_tf_output('photo_uploader_access_key_id')
uploader_secret = get_tf_output('photo_uploader_secret_access_key')
viewer_key = get_tf_output('photo_viewer_access_key_id')
viewer_secret = get_tf_output('photo_viewer_secret_access_key')
cf_domain = get_tf_output('cloudfront_domain_name')  # You need to add this as a Terraform output
key_pair_id = '<Key Pair ID>'  

env_content = f"""PHOTO_UPLOADER_ACCESS_KEY_ID={uploader_key}
PHOTO_UPLOADER_SECRET_ACCESS_KEY={uploader_secret}
PHOTO_VIEWER_ACCESS_KEY_ID={viewer_key}
PHOTO_VIEWER_SECRET_ACCESS_KEY={viewer_secret}
CLOUDFRONT_DOMAIN={cf_domain}
CLOUDFRONT_KEY_PAIR_ID={key_pair_id}
PRIVATE_KEY_FILE_PATH=<Private Key file path>
"""

with open('.env', 'w') as f:
    f.write(env_content)

print("✅ .env file generated")
