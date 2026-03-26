#!/bin/bash
set -euo pipefail

REGION="us-east-1"

echo "Available regions: "
aws ec2 describe-regions --no-cli-pager
echo
echo
echo "Available AZ (availability zones):"
aws ec2 describe-availability-zones --region "${REGION}" \
	--no-cli-pager

