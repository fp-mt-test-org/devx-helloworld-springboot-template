#!/bin/sh

set -eu

publishingTasks=""
if [ "$BUILDKITE_BRANCH" = "master" ] || [ -n "${CD:-}" ]; then
    publishingTasks="publish dockerPush helmPublish"
fi

./gradlew clean build dockerTag $publishingTasks -Pinfra2 "$@"


if [ -s "build/publishedCharts.txt" ]; then
    buildkite-agent artifact upload "build/publishedCharts.txt"
    buildkite-agent meta-data set "TRIGGER_CD" "true"
else
    buildkite-agent meta-data set "TRIGGER_CD" "false"
fi