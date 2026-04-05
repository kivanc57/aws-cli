#!/bin/bash
set -euo pipefail

SERVICE_ARN="$(aws apprunner list-services
	--query 'ServiceSummaryList[0].ServiceArn'\
	--output text)"

aws apprunner delete-service --service-arn "${SERVICE_ARN}"

