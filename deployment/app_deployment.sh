#!/bin/bash
set -euo pipefail

# Script to build Dockerfile

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

docker build \
    --tag "${DOCKER_HUB_USER}"/"${DOCKER_IMAGE_NAME}":"${DOCKER_IMAGE_TAG}" \
    -t "${DOCKER_IMAGE_NAME}" \
    --no-cache \
    ../app

# this is a public docker hub repository
docker_login
docker push "${DOCKER_HUB_USER}"/"${DOCKER_IMAGE_NAME}":"${DOCKER_IMAGE_TAG}"


helm package "${CHART_DIR}"/flask-app
helm_login
helm push "${HELM_CHART_NAME}"-"${HELM_CHART_VERSION}".tgz oci://"${DOCKER_HUB_URL}"/"${DOCKER_HUB_USER}"
#helm_login
#helm uninstall brenntag-api
# possibly you can install from the repository.
# helm install brenntag-api oci://registry-1."${DOCKER_HUB_URL}"/"${DOCKER_HUB_USER}"/"${HELM_CHART_NAME}" --version "${HELM_CHART_VERSION}"
# but I will install from the app directory
helm install brenntag-api ../charts/flask-app -n trino

