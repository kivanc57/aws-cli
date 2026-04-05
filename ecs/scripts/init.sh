#!/bin/bash
set -euo pipefail

STACK="notea"
TEMP="../templates/notea.yaml"

: "${ApplicationId:?ApplicationId is required}"
: "${Password:?Password is required}"

aws cloudformation create-stack \
	--stack-name "${STACK}" \
	--template-body "file://${TEMP}" \
	--parameters \
		ParameterKey=ApplicationID,ParameterValue="$ApplicationId" \
		ParameterKey=Password,ParameterValue="$Password" \
	--capabilities CAPABILITY_IAM

aws cloudformation wait stack-create-complete \
	--stack-name "${STACK}" && aws cloudformation describe-stacks \
	--stack-name "${STACK}" --query "Stacks[0].Outputs[0].OutputValue" \
	--output text

