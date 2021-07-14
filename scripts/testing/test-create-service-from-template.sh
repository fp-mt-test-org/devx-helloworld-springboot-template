#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

# These tests are based on the steps outlined in the README.
# The purpose is to perform the same actions the README is asking
# people to do so we can catch any regressions with it.

generate_project_name() {
    random_string=$(LC_ALL=C tr -dc 'a-z0-9' </dev/urandom | head -c 5 ; echo)
    project_name="devx-helloworld-springboot-${random_string}"

    echo "${project_name}"
}

i=0 # Step counter
owner_name='fp-mt-test-org'
github_base_url="https://github.com/${owner_name}"
template_name="devx-helloworld-springboot-template"
flex='./flex.sh'

echo "=================================="
echo "TEST: Create service from template"
echo "=================================="
echo "Step $((i=i+1)): Generate Unique Project Name"
project_name=$(generate_project_name)
repository_path="${github_base_url}/${project_name}"
echo "Project Name: ${project_name}"

get_actions_curl_command="curl -sH \"Accept: application/vnd.github.v3+json\" -H \"authorization: Bearer ${GITHUB_TOKEN}\" \"https://api.github.com/repos/${owner_name}/${project_name}/actions/runs\""
echo
echo "Step $((i=i+1)): Submit Create Request to Maker Portal"
template_name="${template_name}" project_name="${project_name}" ./scripts/create-project.sh
echo 
echo "Step $((i=i+1)): Wait for GitHub Repo to be Created"
counter=0
max_tries=20
seconds_between_tries=3
while true; do
    echo "${counter} Checking..."
    response=$(eval "${get_actions_curl_command}")

    if [[ "${response}" =~ "Not Found" ]]; then
        echo "${project_name} not yet found."
    else
        echo "Repo found!"
        break
    fi

    if [[ "${max_tries}" == "${counter}" ]]; then
        echo "Giving up after ${max_tries}, test failed!"
        exit 1
    fi

    counter=$((counter+1))
    sleep "${seconds_between_tries}"
done
echo 
# echo "Step $((i=i+1)): Verify CI Build is Successful"
# counter=0
# max_tries=100
# seconds_between_tries=3
# while true; do
#     echo "${counter} Checking for build result..."
#     response=$(eval "$get_actions_curl_command")

#     if [[ "${response}" =~ \"status\"\:[[:space:]]+\"([A-Za-z_]+)\" ]]; then
#         status="${BASH_REMATCH[1]}"
#         echo "status: ${status}"
#     else
#         status="unknown"
#     fi

#     if [[ "${response}" =~ \"conclusion\"\:[[:space:]]+\"*([A-Za-z_]+)\"* ]]; then
#         conclusion="${BASH_REMATCH[1]}"
#         echo "conclusion: ${conclusion}"
#     else
#         conclusion="unknown"
#     fi

#     if [[ "${status}" == "completed" ]]; then
#         if [[ "${conclusion}" != "success" ]]; then
#             echo "Build was not successful, test failed!"
#             exit 1
#         else
#             break
#         fi
#     fi

#     if [[ "${max_tries}" == "${counter}" ]]; then
#         echo "Giving up after ${max_tries}, test failed!"
#         exit 1
#     fi

#     counter=$((counter+1))
#     sleep "${seconds_between_tries}"

#     echo
# done
# echo

echo "Step $((i=i+1)): Verify Artifact was Published"
artifact_url="https://artifactory.flexport.io/artifactory/lib-from-template-mvn-sandbox-local/lib-from-template/1.1.0-SNAPSHOT/lib-from-template-1.1.0-SNAPSHOT.jar"
curl \
    "${artifact_url}" \
    --output lib-from-template-1.1.0-SNAPSHOT.jar
echo "Artifact download successful!"
echo
echo "Step $((i=i+1)): Clone repo locally"
git clone "${repository_path}.git"
cd "${project_name}"
echo
echo "Step $((i=i+1)): Verify Local Build is Successful"
"${flex}" build
echo
echo "Attempting update-template..."
"${flex}" update-template
echo
echo "Passed!"
echo "Step $((i=i+1)): Cleanup"
cd ..
echo "Deleteing ${project_name} locally..."
rm -fdr "${project_name}"
echo "Deleteing ${project_name} remotely..."
curl \
  -X DELETE \
  -H "Accept: application/vnd.github.v3+json" \
  -H "Authorization: token ${GITHUB_TOKEN}" \
   "https://api.github.com/repos/${owner_name}/${project_name}"
echo
echo "Done!"
echo