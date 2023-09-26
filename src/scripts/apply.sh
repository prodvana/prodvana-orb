#!/bin/bash
set -euxo pipefail

pvnctl auth context use "${PARAM_AUTH_CONTEXT}"
pvnctl configs apply "${PARAM_PATH}"