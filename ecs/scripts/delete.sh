#!/bin/bash
set -euo pipefail

STACK="notea"




aws cloudformation delete-stack --stack-name "${STACK}"

aws cloudformation wait stack-delete-complete \
	--stack-name "${STACK}"

