# Flask backend for Secure Photo Sharing App.
# Handles routes for:
# - Generating signed CloudFront GET URLs (/signed-url)
# - Listing uploaded images from S3 (/list-files)
# - Generating S3 pre-signed PUT URLs for uploads (/generate-put-url)
# Uses two IAM users: 
#   - "uploader" (for uploads) 
#   - "viewer" (for listing files).
# AWS credentials are securely loaded from .env.
# /signed-url: returns signed CloudFront URL for viewing an image
# /list-files: lists all images in the uploads bucket
# /generate-put-url: generates S3 pre-signed URL for uploading



from flask import Flask, request, jsonify
from flask_cors import CORS
from generate_signed_url import generate_signed_url
import boto3
import os
from dotenv import load_dotenv

load_dotenv()  # Load .env automatically

app = Flask(__name__)
CORS(app)

BUCKET_NAME = '<Bucket Name>'

# Load uploader creds from .env
uploader_session = boto3.Session(
    aws_access_key_id=os.getenv('UPLOADER_ACCESS_KEY_ID'),
    aws_secret_access_key=os.getenv('UPLOADER_SECRET_ACCESS_KEY')
)
uploader_s3 = uploader_session.client('s3')
print(" Uploader creds loaded from .env")

# Load viewer creds from .env
viewer_key_id = os.getenv('VIEWER_ACCESS_KEY_ID')
viewer_secret = os.getenv('VIEWER_SECRET_ACCESS_KEY')

#  Print debug info for viewer key
print(" Viewer Key ID from .env:", viewer_key_id)

viewer_session = boto3.Session(
    aws_access_key_id=viewer_key_id,
    aws_secret_access_key=viewer_secret
)
viewer_s3 = viewer_session.client('s3')
print(" Viewer creds loaded from .env")

@app.route('/signed-url')
def signed_url():
    filename = request.args.get('file')
    if not filename:
        return jsonify({"error": "Filename required"}), 400

    try:
        url = generate_signed_url(filename)
        return jsonify({"url": url})
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/list-files')
def list_files():
    try:
        response = viewer_s3.list_objects_v2(Bucket=BUCKET_NAME)
        files = [
            obj['Key'] for obj in response.get('Contents', [])
            if obj['Key'].lower().endswith(('.jpg', '.jpeg', '.png', '.gif', '.webp'))
        ]
        return jsonify(files)
    except Exception as e:
        print(f" Error in list-files: {e}")
        return jsonify({"error": str(e)}), 500

@app.route('/generate-put-url')
def generate_put_url():
    filename = request.args.get('filename')
    content_type = request.args.get('content_type', 'image/jpeg')
    if not filename:
        return jsonify({"error": "Filename required"}), 400

    try:
        put_url = uploader_s3.generate_presigned_url(
            ClientMethod='put_object',
            Params={
                'Bucket': BUCKET_NAME,
                'Key': filename,
                'ContentType': content_type,
                'ServerSideEncryption': 'AES256'
            },
            ExpiresIn=300
        )
        return jsonify({'put_url': put_url})
    except Exception as e:
        print(f" Error in generate-put-url: {e}")
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True)
