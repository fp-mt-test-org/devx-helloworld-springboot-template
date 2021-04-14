#!/bin/bash

set -eu

/usr/local/bin/aws eks --region us-east-1 update-kubeconfig --name main

/usr/local/bin/helm repo add artifactory "https://artifactory.flexport.io/artifactory/helm"

while IFS=$'\t' read -r name version; do
    /usr/local/bin/helm -n $DEPLOY_ENV upgrade --install --version "$version" -f src/main/helm/values-${DEPLOY_ENV}.yaml devx-helloworld-springboot "artifactory/$name"
done < build/publishedCharts.txt
