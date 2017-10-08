#!/usr/bin/env bash

#### halt script on error
set -xe

echo '##### Print docker version'
docker --version

echo '##### Print environment'
env | sort

#### Build the Docker Images
if [ -n "${RUBY_VERSION}" ]; then
    cp env.example .env
    sed -i -- "s/RUBY_VERSION=.*/RUBY_VERSION=${RUBY_VERSION}/g" .env
    sed -i -- 's/=false/=true/g' .env
    cat .env
    docker-compose build ${BUILD_SERVICE}
    docker images
fi
