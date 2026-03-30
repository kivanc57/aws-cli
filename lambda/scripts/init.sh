#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT_NAME="$(basename "${BASH_SOURCE[0]}")"
source "${SCRIPT_DIR}/../../utils.sh"

ACCOUNT_ID="$(aws sts get-caller-identity --query Account --output text)"
CLOUD_FORMATION_TEMP="${SCRIPT_DIR}/../templates/template.yaml"
OUTPUT_TEMP_FILE="${SCRIPT_DIR}/../output.yaml"
STACK_NAME="ec2-owner-tag"
BUCKET_NAME="${STACK_NAME}-package-${ACCOUNT_ID}"

aws s3 mb "s3://${BUCKET_NAME}" || true

aws cloudformation package \
    --template-file "${CLOUD_FORMATION_TEMP}" \
    --s3-bucket "${BUCKET_NAME}" \
    --output-template-file "${OUTPUT_TEMP_FILE}"

log "[OK] created dependency package ${OUTPUT_TEMP_FILE}"

aws cloudformation validate-template \
    --template-body "file://${OUTPUT_TEMP_FILE}"

log "[OK] template ${OUTPUT_TEMP_FILE} is valid"

aws cloudformation deploy \
    --stack-name "${STACK_NAME}" \
    --template-file "${OUTPUT_TEMP_FILE}" \
    --capabilities CAPABILITY_IAM

log "[SUCCESS] deployed lambda to stack: ${STACK_NAME}"

