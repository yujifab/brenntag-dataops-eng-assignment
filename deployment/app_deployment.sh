#!/bin/bash
set -euo pipefail

# Script to build your Dockerfile
# Before the push is done, the image is scanned using trivy to find possible security issues.
# Please run the trivy-fs step before your Docker build to scan your application code.
# Documentation: https://aquasecurity.github.io/trivy/v0.29.2/docs/

# Set variables.
source variables.sh
docker_login () {
    echo "${DOCKER_HUB_TOKEN}" | docker login --username "${DOCKER_HUB_USER}" --password-stdin "${DOCKER_HUB_URL}"

    trap 'docker logout ${DOCKER_HUB_URL}' EXIT
}
helm_login () {
    # Log in to the registry (and make sure we always log out on EXIT)
    echo "${DOCKER_HUB_TOKEN}" | helm registry login "${DOCKER_HUB_URL}" --username "${DOCKER_HUB_USER}" --password-stdin "${DOCKER_HUB_URL}"

    trap 'helm registry logout ${DOCKER_HUB_URL}' EXIT
}
# Get version from version file (./version) in the root of your project.
docker build \
    --tag "${DOCKER_HUB_USER}"/"${DOCKER_IMAGE_NAME}":"${DOCKER_IMAGE_TAG}" \
    -t ${DOCKER_IMAGE_NAME} \
    --no-cache \
    ..

# this is a public docker hub repository
#docker login --username "${DOCKER_HUB_REPO}" --password "${DOCKER_HUB_PWD}"
docker_login
docker push "${DOCKER_HUB_USER}"/"${DOCKER_IMAGE_NAME}":"${DOCKER_IMAGE_TAG}"

helm package ../charts/flask-app
helm_login
helm push "${HELM_CHART_NAME}"-"${HELM_CHART_VERSION}".tgz oci://"${DOCKER_HUB_URL}"/"${DOCKER_HUB_USER}"
#docker run -p 5050:80 ${DOCKER_IMAGE_NAME}


#helm install my-flask-app ./flask-app-0.1.0.tgz
helm upgrade brenntag-api oci://registry-1."${DOCKER_HUB_URL}"/"${DOCKER_HUB_USER}"/"${HELM_CHART_NAME}" --version "${HELM_CHART_VERSION}"

