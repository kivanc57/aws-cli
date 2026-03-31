#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT_NAME="$(basename "${BASH_SOURCE[0]}")"
source "${SCRIPT_DIR}/../../utils.sh"

DB="wordpress"
TEMP="${SCRIPT_DIR}/../templates/template.yaml"
SNAPSHOT="${DB}-manual-snapshot"

aws cloudformation validate-template \
	--template-body "file://${TEMP}"

log "[OK] template: ${TEMP} is validated"

aws cloudformation create-stack \
	--stack-name "${DB}" \
	--template-body "file://${TEMP}" \
	--parameters "ParameterKey=WordpressAdminPassword,ParameterValue=test1234" \
	--capabilities CAPABILITY_IAM

aws cloudformation wait stack-create-complete

log "[SUCCESS] stack: ${DB} created"

aws cloudformation describe-stacks \
	 --stack-name ${DB} \
	 --no-cli-pager


DB_INSTANCE_ID="$(aws rds describe-db-instances --output text \
	--query "DBInstances[0].DBInstanceIdentifier")"

aws rds create-db-snapshot --db-snapshot-identifier "${SNAPSHOT}"
	--db-instance-identifier "${DB_INSTANCE_ID}"

log "[SUCCESS] creating snapshot: ${SNAPSHOT} of db: ${DB}"

aws rds describe-db-snapshots --db-snapshot-identifier "${DB_INSTANCE_ID}"

