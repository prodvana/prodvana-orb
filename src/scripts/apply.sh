#!/bin/bash
set -euxo pipefail

pvnctl auth context use "${PARAM_AUTH_CONTEXT}"
pvnctl configs "${PARAM_TYPE}" apply "${PARAM_PATH}"