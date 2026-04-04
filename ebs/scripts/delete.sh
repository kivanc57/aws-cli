#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT_NAME="$(basename "${BASH_SOURCE[0]}")"
source "${SCRIPT_DIR}/../../utils.sh"


VOLUME_ID="$(aws ec2 describe-volumes \
	--query 'Volumes[0].VolumeId' \
	--output text)"

SNAPSHOT_ID="$(aws ec2 describe-snapshots \
    --owner-ids self \
    --filters "Name=volume-id,Values=${VOLUME_ID}" \
    --query 'Snapshots[0].SnapshotId' \
    --output text)"

aws ec2 delete-snapshot --snapshot-id "${SNAPSHOT_ID}"

log "[OK] deleted snapshot: ${SNAPSHOT_ID}"

aws ec2 delete-volume --volume-id "${VOLUME_ID}"

log "[SUCCESS] deleted volume: ${VOLUME_ID}"

