#!/bin/bash
set -euxo pipefail

ADDL_FLAGS=""
if [[ -n ${PARAM_WAIT_CHANNELS} ]]; then
	ADDL_FLAGS="--wait-channel='${PARAM_WAIT_CHANNELS}'"
fi
pvnctl auth context add default "api.${PARAM_ORG}.prodvana.io:5000"
pvnctl auth token "${PARAM_API_TOKEN}"
pvnctl services update-images "${PARAM_SERVICE}" --image "${PARAM_DOCKER_IMAGE}" "${ADDL_FLAGS}"
