#!/bin/bash
set -euo pipefail

INSTANCE_ID="$(aws ec2 describe-instances \
        --query 'Reservations[0].Instances[0].InstanceId' \
        --output text)"

aws ssm start-session --target "${INSTANCE_ID}"

