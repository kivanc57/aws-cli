#!/bin/bash
set -euo pipefail

# script constants
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT_NAME="$(basename "${BASH_SOURCE[0]}")"

STACK_NAME="ec2-owner-tag"

aws cloudformation describe-stack-events \
	--stack-name "${STACK_NAME}" \
	--max-items 20 | tee "${SCRIPT_DIR}/../stack-events.json"

