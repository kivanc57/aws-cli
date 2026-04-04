#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT_NAME="$(basename "${BASH_SOURCE[0]}")"
source "${SCRIPT_DIR}/../../utils.sh"

ZONE="us-east-1a"

VOLUME_ID="$(aws ec2 create-volume \
	--availability-zone "${ZONE}" \
	--size 20 \
	--volume-type gp3 \
	--query 'VolumeId' \
	--output text)"

aws ec2 wait volume-available --volume-ids "${VOLUME_ID}"
log "[OK] created volume: ${VOLUME_ID}"

aws ec2 describe-volumes --volume-ids "${VOLUME_ID}"


SNAPSHOT_ID="$(aws ec2 create-snapshot \
	--volume-id "${VOLUME_ID}" \
	--description "Snapshot of ${VOLUME_ID}" \
	--query "SnapshotId" \
	--output text)"

aws ec2 wait snapshot-completed --snapshot-ids "${SNAPSHOT_ID}"

log "[OK] created snapshot: ${SNAPSHOT_ID} for the volume: ${VOLUME_ID}"

aws ec2 describe-snapshots --snapshot-ids "${SNAPSHOT_ID}"

