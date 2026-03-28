#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT_NAME="$(basename "${BASH_SOURCE[0]}")"

BUCKET_NAME="my-web-gallery"

aws s3 mb s3://"${BUCKET_NAME}"

cd "${SCRIPT_DIR}/.."
npm install
node server.js "${BUCKET_NAME}"

