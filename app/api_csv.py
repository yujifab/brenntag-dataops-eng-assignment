from flask import Flask, request, jsonify, render_template
from flask_wtf import FlaskForm
from wtforms import FileField, SubmitField
import os
from wtforms.validators import InputRequired
from minio import Minio
from minio.error import S3Error
import logging

app = Flask(__name__)
app.config['SECRET_KEY'] = 'supersecretkey'

# MinIO configuration
# minio_endpoint = '127.0.0.1:9000'  # this is for local
minio_endpoint = "my-minio.trino.svc.cluster.local:9000"  # this is for docker
minio_access_key = 'minio_access_key'
minio_secret_key = 'minio_secret_key'
minio_bucket_name = 'warehouse'

logging.info("INIT")


class UploadFileForm(FlaskForm):
    file = FileField("File", validators=[InputRequired()])
    submit = SubmitField("Upload File")


# Initialize MinIO client
minio_client = Minio(minio_endpoint,
                     access_key=minio_access_key,
                     secret_key=minio_secret_key,
                     secure=False)  # Set to True if your MinIO server uses HTTPS

# Ensure that the bucket exists
if not minio_client.bucket_exists(minio_bucket_name):
    minio_client.make_bucket(minio_bucket_name)


@app.route('/', methods=['GET', "POST"])
@app.route('/home', methods=['GET', "POST"])
def home():
    form = UploadFileForm()
    if form.validate_on_submit():
        file = form.file.data  # First grab the file
        temp_file_path = 'temp.csv'
        file.save(temp_file_path)
        try:
            # Upload the file to MinIO
            minio_client.fput_object(minio_bucket_name, file.filename, temp_file_path)
        except S3Error as e:
            return jsonify({'error': str(e)}), 500
        # Then save the file
        return jsonify({'message': 'File uploaded successfully'}), 200
    return render_template('index.html', form=form)


if __name__ == '__main__':
    port = int(os.environ.get('PORT', 5001))
    app.run(debug=True, host='0.0.0.0', port=port)