# syntax=docker/dockerfile:1

# Comments are provided throughout this file to help you get started.
# If you need more help, visit the Dockerfile reference guide at
# https://docs.docker.com/engine/reference/builder/

ARG PYTHON_VERSION=3.9.6
FROM python:${PYTHON_VERSION}-slim as base

# Prevents Python from writing pyc files.
ENV PYTHONDONTWRITEBYTECODE=1

# Keeps Python from buffering stdout and stderr to avoid situations where
# the application crashes without emitting any logs due to buffering.
ENV PYTHONUNBUFFERED=1

# Set the working directory to /app
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY ../.. /app

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Make port 80 available to the world outside this container
EXPOSE 80

# Define environment variable
ENV FLASK_APP api_csv.py

# Run app.py when the container launches
#CMD ["flask", "run", "--host=0.0.0.0", "--port=5001"]
# configure the container to run in an executed manner
ENTRYPOINT [ "python" ]

CMD ["api_csv.py" ]

#This assumes that your Flask application inside the container is listening on port 80. The -p 5000:80 flag maps port 5000 on your host to port 80 in the container.
#Now, your Flask application should be accessible at http://127.0.0.1:5000/upload. If your MinIO server is running locally, make sure to update the minio_endpoint in your app.py to the appropriate URL accessible from within the Docker container. If the MinIO server is running on the host machine, you might need to use the host machine's IP address instead of localhost or 127.0.0.1.





