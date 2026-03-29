#!/bin/bash
set -euo pipefail

# script constants
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT_NAME="$(basename "${BASH_SOURCE[0]}")"

source "${SCRIPT_DIR}/../utils.sh"

GROUP_NAME="admin"

# read credentials
read -rp "enter username: " USERNAME
read -rp "enter password: " PASSWORD

# create & attach admin policies if group does NOT exist
if ! aws iam get-group --group-name "${GROUP_NAME}" >/dev/null 2>&1; then
	log "[WARN] admin group is NOT found. Creating..."
	aws iam create-group --group-name "${GROUP_NAME}"
	aws iam attach-group-policy --group-name ${GROUP_NAME} \
		--policy-arn "arn:aws:iam::aws:policy/AdministratorAccess"
fi

aws iam create-user --user-name "${USERNAME}"

log "[OK] created user ${USERNAME}"

aws iam add-user-to-group --group-name "${GROUP_NAME}" --user-name "${USERNAME}"

log "[OK] adding user: ${USERNAME} into group: ${GROUP_NAME}"

aws iam create-login-profile --user-name "${USERNAME}" --password "${PASSWORD}" --password-reset-required

log "[SUCCESS] Created admin login profile for user: ${USERNAME}"

