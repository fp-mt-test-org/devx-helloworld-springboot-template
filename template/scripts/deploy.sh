#!/usr/bin/env bash

set -e

./scripts/setup-kubectl-for-gcloud.sh

helm upgrade --install --atomic springtest src/main/helm -n default -f src/main/helm/values-"${ENV}.yaml" --set config.image.tag="${TAG}"
