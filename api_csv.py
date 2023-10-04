from flask import Flask, request, jsonify
from minio import Minio
from minio.error import S3Error
import os

app = Flask(__name__)

# MinIO configuration
minio_endpoint = 'my-minio'  # Replace with your MinIO server URL
minio_access_key = 'minio_access_key'
minio_secret_key = 'minio_secret_key'
minio_bucket_name = 'warehouse'

# Initialize MinIO client
minio_client = Minio(minio_endpoint,
                     access_key=minio_access_key,
                     secret_key=minio_secret_key,
                     secure=False)  # Set to True if your MinIO server uses HTTPS

# Ensure that the bucket exists
if not minio_client.bucket_exists(minio_bucket_name):
    minio_client.make_bucket(minio_bucket_name)

@app.route('/upload', methods=['POST'])
def upload_file():
    try:
        # Check if the post request has the file part
        if 'file' not in request.files:
            return jsonify({'error': 'No file part'}), 400

        file = request.files['file']

        # If the user does not select a file, the browser may also
        # submit an empty file without a filename.
        if file.filename == '':
            return jsonify({'error': 'No selected file'}), 400

        # Save the file to a temporary location
        temp_file_path = 'temp.csv'
        file.save(temp_file_path)

        # Upload the file to MinIO
        minio_client.fput_object(minio_bucket_name, file.filename, temp_file_path)

        # Remove the temporary file
        os.remove(temp_file_path)

        return jsonify({'message': 'File uploaded successfully'}), 200

    except S3Error as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True)
