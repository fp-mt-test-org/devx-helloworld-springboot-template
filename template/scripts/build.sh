#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

default_branch=$([ -f .git/refs/heads/main ] && echo main || echo master)
current_branch=$(git branch --show-current)

echo "Installing svu..."
brew install caarlos0/tap/svu
echo "Install complete."
echo

if [[ "${default_branch}" == "${current_branch}" ]]; then
    next_version="$(svu n)"
else
    next_version="$(svu n)-SNAPSHOT"
fi

echo "Next Version: ${next_version}"
echo

./mvnw -Drevision="${next_version}" spring-boot:build-image

# Using current dir name as service_name for short term...
# Long term, a repo may host multiple services...
service_name="${PWD##*/}"
artifact_tag="${service_name}:${next_version}"

docker tag "${artifact_tag}" "${service_name}:latest"
