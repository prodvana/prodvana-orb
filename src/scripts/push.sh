#!/bin/bash
set -euxo pipefail

if [[ -n "${PARAM_DOCKER_IMAGE}" && -n "${PARAM_DOCKER_IMAGE_BY_RELEASE_CHANNEL}" ]]; then
    echo "Only one of docker-image or docker-image-by-release-channel can be set!"
    exit 1
fi

# Evaluate env vars in image name
PARAM_DOCKER_IMAGE=$(eval echo "${PARAM_DOCKER_IMAGE}")
PARAM_DOCKER_IMAGE_BY_RELEASE_CHANNEL=$(eval echo "${PARAM_DOCKER_IMAGE_BY_RELEASE_CHANNEL}")

CMD="pvnctl services --app=${PARAM_APP} update-images ${PARAM_SERVICE}"

if [[ -n ${PARAM_DOCKER_IMAGE} ]]; then
    CMD="$CMD --image ${PARAM_DOCKER_IMAGE}"
elif [[ -n ${PARAM_DOCKER_IMAGE_BY_RELEASE_CHANNEL} ]]; then
    CMD="$CMD --images-by-release-channel ${PARAM_DOCKER_IMAGE_BY_RELEASE_CHANNEL}"
else
    echo "One of docker-image or docker-image-by-release-channel must be set!"
    exit 1
fi

if [[ -n ${PARAM_WAIT_CHANNELS} ]]; then
    CMD="$CMD --wait-channel=${PARAM_WAIT_CHANNELS}"
fi

pvnctl auth context use "${PARAM_AUTH_CONTEXT}"
eval "${CMD}"
