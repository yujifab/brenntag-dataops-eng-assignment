#!/bin/bash


# Define minio root user
MIN_USR="rootuser"
# Secret key length at least 8 characters for minio
MIN_PW="Labk8s01!"
PG_PW="Labk8s01!"
REGISTRY="111111111111.dkr.ecr.us-east-1.amazonaws.com/hive"
#Docker image name
HELM_CHART_NAME="flask-app"
HELM_CHART_VERSION="0.1.0"
DOCKER_IMAGE_NAME="brenntag_api_csv"
DOCKER_HUB_URL="docker.io"
DOCKER_HUB_USER="yujifab"
DOCKER_HUB_PWD="YjnwD#S_/FWE7P^"
DOCKER_HUB_TOKEN="dckr_pat_Oh-OYnmSAZr7cgHeto8apaYEDoE"
DOCKER_IMAGE_TAG="api_csv"

export MIN_USR MIN_PW PG_PW REGISTRY