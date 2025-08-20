# Generates a signed CloudFront URL for securely viewing images.
# Uses:
# - CLOUDFRONT_DOMAIN (auto-injected by automation script)
# - KEY_PAIR_ID (CloudFront key pair for signing)
# - PRIVATE_KEY_FILE (local private key path for signing).
# Returns a signed URL valid for a limited time window.
# This file is auto-updated when new CloudFront distributions are created.
# Generates signed CloudFront URL for secure access
# Uses private key and CloudFront key pair
# Auto-updated by deploy.sh with current CloudFront domain


import datetime
from urllib.parse import quote
from cryptography.hazmat.primitives import serialization, hashes
from cryptography.hazmat.primitives.asymmetric import padding
import base64

# Auto-updated by deploy.sh — confirm this got updated correctly
CLOUDFRONT_DOMAIN = '<CF domain name>'
KEY_PAIR_ID = '<Key pair ID>'

# Path to your private key file
PRIVATE_KEY_FILE = r"<Private key path>"

def generate_signed_url(object_key, expires_in_minutes=10):
    expires = int((datetime.datetime.now(datetime.timezone.utc) + datetime.timedelta(minutes=expires_in_minutes)).timestamp())

    policy = f"""{{
      "Statement": [
        {{
          "Resource": "https://{CLOUDFRONT_DOMAIN}/{object_key}",
          "Condition": {{
            "DateLessThan": {{
              "AWS:EpochTime": {expires}
            }}
          }}
        }}
      ]
    }}"""

    with open(PRIVATE_KEY_FILE, 'rb') as key_file:
        private_key = serialization.load_pem_private_key(key_file.read(), password=None)

    signature = private_key.sign(
        policy.encode('utf-8'),
        padding.PKCS1v15(),
        hashes.SHA1()
    )

    encoded_sig = quote(base64.b64encode(signature))
    encoded_policy = quote(base64.b64encode(policy.encode('utf-8')))

    signed_url = (
        f"https://{CLOUDFRONT_DOMAIN}/{object_key}"
        f"?Policy={encoded_policy}"
        f"&Signature={encoded_sig}"
        f"&Key-Pair-Id={KEY_PAIR_ID}"
    )

    # Debug print — see what URL was generated
    print(" Generated signed URL:", signed_url)

    return signed_url
