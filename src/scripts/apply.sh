#!/bin/bash
set -euxo pipefail

# Evaluate globs
PARAM_PATH=$(eval echo "${PARAM_PATH}")

pvnctl auth context use "${PARAM_AUTH_CONTEXT}"
# intentionally not quoting PARAM_PATH so that wildcards get evaluated.
pvnctl configs "${PARAM_TYPE}" apply "${PARAM_PATH}"