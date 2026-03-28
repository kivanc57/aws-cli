#!/bin/bash
set -euo pipefail

BUCKET_NAME="olomouc-web"

aws s3 rb "s3://${BUCKET_NAME}" --force

