#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

echo "Installing svu..."
brew install caarlos0/tap/svu
echo "Install complete."
echo

default_branch=$([ -f .git/refs/heads/master ] && echo master || echo main)
current_branch=$(git branch --show-current)

next_version="$(svu n)"

if [[ "${default_branch}" == "${current_branch}" ]]; then
    maturity_level="dev"

    echo "Tagging repo with ${next_version}"
    git tag "${next_version}"

    echo "Pushing tags"
    git push --tags
else
    next_version="${next_version}-SNAPSHOT"
    maturity_level="snapshot"
fi

echo "Next Version: ${next_version}"
echo

artifactory_hostname=$(basename "${artifactory_base_url}")
artifact_repository_name="${service_name}-docker-${maturity_level}-local"
artifact_tag="${service_name}:${next_version}"
artifact_remote_tag="${artifactory_hostname}/${artifact_repository_name}/${artifact_tag}"

docker tag "${artifact_tag}" "${artifact_remote_tag}"

echo "Installing jfrog cli..."
brew install jfrog-cli

echo "Tagged ${artifact_tag} as ${artifact_remote_tag}"
echo
echo "Pushing ${artifact_remote_tag} to ${artifact_repository_name}"
echo
jfrog rt \
    docker-push "${artifact_remote_tag}" \
    "${artifact_repository_name}" \
    --build-name="${service_name}" \
    --build-number=6.0.0 \
    --url="${artifactory_base_url}/artifactory" \
    --user="${artifactory_username}" \
    --access-token="${artifactory_password}"

echo
echo "jfrog docker-push completed successfully."
