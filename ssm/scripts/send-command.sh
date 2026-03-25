#!/bin/bash
set -euo pipefail

INSTANCE_ID="$(aws ec2 describe-instances \
	--query 'Reservations[0].Instances[0].InstanceId' \
	--output text)"

aws ssm send-command \
	--instance-ids "${INSTANCE_ID}" \
	--document-name "AWS-RunShellScript" \
	--no-cli-pager \
	--parameters 'commands=[
		"sudo mkfs -t ext4 /dev/xvdf",
		"sudo mkdir -p /data",
		"sudo mount /dev/xvdf /data",
		"echo hello | sudo tee /data/test.txt"
	]'

