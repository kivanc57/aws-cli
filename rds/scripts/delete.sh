#!/bin/bash
set -euo pipefail

STACK_NAME="wordpress"
DB="wordpress"
SNAPSHOT="${DB}-manual-snapshot"

aws cloudformation delete-stack --stack-name "${STACK_NAME}"

aws rds delete-db-instance --db-instance-identifier "${DB}"

aws rds delete-db-snaphot --db-snapshot-identifier "${SNAPSHOT}"

