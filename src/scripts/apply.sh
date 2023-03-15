#!/bin/bash
set -euxo pipefail

# Evaluate globs
PARAM_PATH=$(eval echo "${PARAM_PATH}")
PARAM_ARRAY=(`echo ${PARAM_PATH} | tr ' ' ' '`)

pvnctl auth context use "${PARAM_AUTH_CONTEXT}"
pvnctl configs "${PARAM_TYPE}" apply "${PARAM_PATH[@]}"