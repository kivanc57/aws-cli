#!/bin/bash
set -euo pipefail

# after initialization, follow this pattern to access the website:
# http://${bucketname}.s3-website-${amazon-sv}.amazonaws.com
# 
# for example:
#	http://olomouc-web.s3-website-us-east-1.amazonaws.com


# script constants
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT_NAME="$(basename "${BASH_SOURCE[0]}")"

# app-spec constants
BUCKET_NAME="olomouc-web"
INDEX_PAGE="index.html"
POLICY="${SCRIPT_DIR}/../bucketpolicy.json"

# create bucket
aws s3 mb "s3://${BUCKET_NAME}"

# copy index page
aws s3 cp "${INDEX_PAGE}" "s3://${BUCKET_NAME}/${INDEX_PAGE}"

# change policy to access
aws s3api put-public-access-block \
  --bucket "${BUCKET_NAME}" \
  --public-access-block-configuration \
  '{"BlockPublicAcls":true,"IgnorePublicAcls":true,"BlockPublicPolicy":false,"RestrictPublicBuckets":false}'

# put bucket policy
aws s3api put-bucket-policy --bucket "${BUCKET_NAME}" \
	--policy "file://${POLICY}"

# enable website
aws s3 website "s3://${BUCKET_NAME}" --index-document "${INDEX_PAGE}"

