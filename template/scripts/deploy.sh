#!/usr/bin/env bash

set -e

echo "--- Assume infra_builder role for account EngDev04 238801556584"
OUTPUT=$(aws sts assume-role --role-arn arn:aws:iam::238801556584:role/infra_builder --role-session-name cd)
export AWS_ACCESS_KEY_ID=$(echo $OUTPUT | jq ".Credentials.AccessKeyId" | tr -d '"')
export AWS_SECRET_ACCESS_KEY=$(echo $OUTPUT | jq ".Credentials.SecretAccessKey" | tr -d '"')
export AWS_SESSION_TOKEN=$(echo $OUTPUT | jq ".Credentials.SessionToken" | tr -d '"')

helm upgrade --install --atomic springtest src/main/helm -n default -f src/main/helm/values-"${ENV}.yaml" --set config.image.tag="${TAG}"
