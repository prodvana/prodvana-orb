#!/bin/bash
set -euxo pipefail

if [[ -n "${PARAM_DOCKER_IMAGE}" && -n "${PARAM_DOCKER_IMAGE_BY_RELEASE_CHANNEL}" ]]; then
    echo "Only one of docker-image or docker-image-by-release-channel can be set!"
    exit 1
fi

if [[ -n "${PARAM_PARAMS}" && -n "${PARAM_PARAMS_BY_RELEASE_CHANNEL}" ]]; then
    echo "Only one of params or params-by-release-channel can be set!"
    exit 1
fi

# TODO: We're not validating full 4x4 param exclusion. DOCKER_IMAGE* is deprecated.

# Evaluate env vars in image name
PARAM_DOCKER_IMAGE=$(eval echo "${PARAM_DOCKER_IMAGE}")
PARAM_DOCKER_IMAGE_BY_RELEASE_CHANNEL=$(eval echo "${PARAM_DOCKER_IMAGE_BY_RELEASE_CHANNEL}")

CMD="pvnctl services --app=${PARAM_APP}"

if [[ -n ${PARAM_PARAMS} ]]; then
    CMD="$CMD push2 ${PARAM_SERVICE}"
    IFS="," read -ra PARAM_SPLIT <<< "${PARAM_PARAMS}"
    for i in "${PARAM_SPLIT[@]}"; do
	CMD="$CMD --param ${i}"
    done
elif [[ -n ${PARAM_PARAMS_BY_RELEASE_CHANNEL} ]]; then
    CMD="$CMD push2 ${PARAM_SERVICE} --param-by-release-channel ${PARAM_PARAMS_BY_RELEASE_CHANNEL}"
elif [[ -n ${PARAM_DOCKER_IMAGE} ]]; then
    CMD="$CMD update-images ${PARAM_SERVICE} --image ${PARAM_DOCKER_IMAGE}"
elif [[ -n ${PARAM_DOCKER_IMAGE_BY_RELEASE_CHANNEL} ]]; then
    CMD="$CMD update-images ${PARAM_SERVICE} --images-by-release-channel ${PARAM_DOCKER_IMAGE_BY_RELEASE_CHANNEL}"
else
    echo "One of params or params-by-release-channel or docker-image or docker-image-by-release-channel must be set!"
    exit 1
fi

if [[ -n ${PARAM_WAIT_CHANNELS} ]]; then
    CMD="$CMD --wait-channel=${PARAM_WAIT_CHANNELS}"
fi

pvnctl auth context use "${PARAM_AUTH_CONTEXT}"
eval "${CMD}"
