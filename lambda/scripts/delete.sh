#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT_NAME="$(basename "${BASH_SOURCE[0]}")"
source "${SCRIPT_DIR}/../../utils.sh"

ACCOUNT_ID="$(aws sts get-caller-identity --query Account --output text)"
STACK_NAME="ec2-owner-tag"
BUCKET_NAME="${STACK_NAME}-package-${ACCOUNT_ID}"


aws cloudformation delete-stack --stack-name "${STACK_NAME}" 

log "[SUCCESS] stack: ${STACK_NAME} deleted"

aws s3 rb "s3://${BUCKET_NAME}" --force

log "[SUCCESS] bucket: ${BUCKET_NAME} deleted"

