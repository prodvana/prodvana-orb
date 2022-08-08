#!/bin/bash
set -euxo pipefail

# Evaluate env vars in image name
PARAM_DOCKER_IMAGE=$(eval echo "${PARAM_DOCKER_IMAGE}")

CMD="pvnctl services update-images ${PARAM_SERVICE} --image ${PARAM_DOCKER_IMAGE}"
if [[ -n ${PARAM_WAIT_CHANNELS} ]]; then
    CMD="$CMD --wait-channel=${PARAM_WAIT_CHANNELS}"
fi

pvnctl auth context use "${PARAM_AUTH_CONTEXT}"
eval "${CMD}"
