#!/bin/bash
set -euo pipefail

# script constants
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT_NAME="$(basename "${BASH_SOURCE[0]}")"

source "${SCRIPT_DIR}/../utils.sh"

GROUP_NAME="admin"

AMIID=$(aws ssm get-parameters \
 	--names /aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2 \
 	--query "Parameters[0].Value" \
	--output text)

VPCID="$(aws ec2 describe-vpcs \
	--filters "Name=isDefault, Values=true" \
	--query "Vpcs[0].VpcId" \
	--output text)"

SUBNETID="$(aws ec2 describe-subnets \
	--filters "Name=vpc-id, Values=$VPCID" \
	--query "Subnets[0].SubnetId" \
	--output text)"

INSTANCEID="$(aws ec2 run-instances \
	--image-id "$AMIID" \
	--instance-type t3.micro \
	--subnet-id "$SUBNETID" \
	--iam-instance-profile "Name=ec2-ssm-core" \
	--query "Instances[0].InstanceId" \
	--output text)"

log "waiting for $INSTANCEID ..."
aws ec2 wait instance-running --instance-ids "$INSTANCEID"
log "$INSTANCEID is up and running"
log "connect to the instance using Session Manager"
log "https://console.aws.amazon.com/systems-manager/session-manager/$INSTANCEID"
read -r -p "Press [Enter] key to terminate $INSTANCEID ..."
aws ec2 terminate-instances --instance-ids "$INSTANCEID" > /dev/null
log "terminating $INSTANCEID ..."
aws ec2 wait instance-terminated --instance-ids "$INSTANCEID"
log "done."

