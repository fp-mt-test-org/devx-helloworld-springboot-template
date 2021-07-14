#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

backstage_backend_base_url="${backstage_backend_base_url:=https://backstage.nonp-dev-4.use1.eng-nonprod.flexport.internal}"
template_name="${template_name:=devx-helloworld-springboot-template}"
project_name="${project_name:=sample-project}"
github_base_url="${github_base_url:=https://github.com/fp-mt-test-org}"

create_project_json="{
    \"templateName\": \"${template_name}\",
    \"values\": {
        \"name\": \"${project_name}\",
        \"http_port\": 8080
    }
}"

response=$(curl -s \
    -X POST -H "Content-Type: application/json" \
    -d "${create_project_json}" \
    "${backstage_backend_base_url}/api/scaffolder/v2/tasks")

if [[ $response =~ \{\"id\"\:\"(.+)\"\} ]]; then
    create_request_id="${BASH_REMATCH[1]}"
    echo "${backstage_backend_base_url}/create/tasks/${create_request_id}"
fi
