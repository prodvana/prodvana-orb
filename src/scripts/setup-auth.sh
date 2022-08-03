#!/bin/bash
set -euxo pipefail

PARAM_API_TOKEN=$(eval echo "\$$PARAM_API_TOKEN")

pvnctl auth context add "${PARAM_CONTEXT}" "api.${PARAM_ORG}.prodvana.io:5000"
pvnctl auth token "${PARAM_API_TOKEN}"
