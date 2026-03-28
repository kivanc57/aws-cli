#!/bin/bash
set -euo pipefail

BUCKET_NAME="my-web-gallery"

aws s3 rb "s3://${BUCKET_NAME}" --force

