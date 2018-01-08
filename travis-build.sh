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

  sed -i -- "s/APP=.*/APP=myapp/g" .env
  sed -i -- "s/RUBY_DB_ADAPTER=.*/RUBY_DB_ADAPTER=postgresql/g" .env
  sed -i -- "s/RUBY_DB_HOST=.*/RUBY_DB_HOST=postgres/g" .env
  sed -i -- "s/RUBY_DB_PORT=.*/RUBY_DB_PORT=5432/g" .env
  docker-compose run ruby rails-new myapp postgresql
  docker-compose up -d ruby postgres
  docker-compose run ruby env
  sleep 5
  docker-compose run ruby bash -c 'cd myapp && bin/rails db:create'
  docker-compose run ruby bash -c 'cd myapp && bin/rails db:migrate'
  docker-compose run ruby bash -c 'cd myapp && bin/rails db:setup'

  docker-compose down -v

  sed -i -- "s/APP=.*/APP=myapp2/g" .env
  sed -i -- "s/RUBY_DB_ADAPTER=.*/RUBY_DB_ADAPTER=mysql2/g" .env
  sed -i -- "s/RUBY_DB_HOST=.*/RUBY_DB_HOST=mysql/g" .env
  sed -i -- "s/RUBY_DB_PORT=.*/RUBY_DB_PORT=3306/g" .env
  docker-compose run ruby rails-new myapp2 mysql
  docker-compose up -d ruby mysql
  docker-compose run ruby env
  sleep 10
  docker-compose run ruby bash -c 'cd myapp2 && bin/rails db:create'
  docker-compose run ruby bash -c 'cd myapp2 && bin/rails db:migrate'
  docker-compose run ruby bash -c 'cd myapp2 && bin/rails db:setup'

  docker-compose down -v
fi
