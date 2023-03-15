#!/bin/bash
set -euxo pipefail

# Evaluate globs
PARAM_PATH=$(eval echo "${PARAM_PATH}")
PARAM_ARRAY=()
while IFS='' read -r line; do PARAM_ARRAY+=("$line"); done < <("${PARAM_PATH}")

pvnctl auth context use "${PARAM_AUTH_CONTEXT}"
pvnctl configs "${PARAM_TYPE}" apply "${PARAM_ARRAY[@]}"