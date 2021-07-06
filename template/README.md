## Build

    flex build

## Running Locally w/ Docker

After a successful build, you can run it like so:

    docker run -p  {{cookiecutter.http_port}}:{{cookiecutter.http_port}} {{cookiecutter.component_id}}:latest

After it starts, you can hit the health check endpoint:

    curl localhost:{{cookiecutter.http_port}}/actuator/health
    {"status":"UP"}

## Running w/ Kubernetes

    flex deploy

## Publish Build to Artifactory

    flex publish
