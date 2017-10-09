#!/usr/bin/env bash

#### halt script on error
set -xe

echo '##### Print docker version'
docker --version

echo '##### Print environment'
env | sort

#### Build the Docker Images
if [ -n "${MY_RUBY_VERSION}" ]; then
  cp env.example .env
  sed -i -- "s/MY_RUBY_VERSION=.*/MY_RUBY_VERSION=${MY_RUBY_VERSION}/g" .env
  sed -i -- "s/RUBY_RAILS_VERSION=.*/RUBY_RAILS_VERSION=${RUBY_RAILS_VERSION}/g" .env
  sed -i -- 's/=false/=true/g' .env

  cat .env

  cp docker-compose.linux.yml docker-compose.override.yml

  docker-compose build ruby
  docker images

  docker-compose run ruby gem install rails -v $RUBY_RAILS_VERSION

  sed -i -- "s/RUBY_DB_ADAPTER=.*/RUBY_DB_ADAPTER=postgresql/g" .env
  sed -i -- "s/RUBY_DB_HOST=.*/RUBY_DB_HOST=postgres/g" .env
  sed -i -- "s/RUBY_DB_PORT=.*/RUBY_DB_PORT=5432/g" .env
  docker-compose run ruby rails-new postgresql
  docker-compose up -d ruby postgres
  docker-compose run ruby env
  docker-compose run ruby rails db:create
  docker-compose run ruby rails db:migrate
  docker-compose run ruby rails db:setup

  docker-compose down -v
fi
