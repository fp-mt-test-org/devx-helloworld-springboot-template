#!/usr/bin/env bash

if [ "$MANUAL_DEPLOY" = "false" ]; then
    export QUEUE="fpos-staging-nonprod-deploy"
    export DEPLOY_ENV="staging"
else
    export QUEUE="fpos-dev-1-nonprod-deploy"
    export DEPLOY_ENV="development"
fi
