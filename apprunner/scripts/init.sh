#!/bin/bash
set -euo pipefail

aws apprunner create-service \
  --service-name simple \
  --source-configuration '{
    "ImageRepository": {
      "ImageIdentifier": "public.ecr.aws/s5r5a1t5/simple:latest",
      "ImageRepositoryType": "ECR_PUBLIC",
      "ImageConfiguration": {
        "Port": "3000"
      }
    }
  }'

