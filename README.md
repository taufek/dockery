# Dockery [![Build Status](https://travis-ci.org/taufek/dockery.svg?branch=master)](https://travis-ci.org/taufek/dockery) [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Docker for Ruby. Docker Containers for Ruby Development Enviroment. It is heavily inspired by
[Laradock](https://github.com/laradock/laradock) project.

* [Getting Started](#getting-started)
	* [Environment Values](#environment-values)
	* [Files and Folders](#files-and-folders)
	* [Docker-Sync-Specific Setup](#docker-sync-specific-setup)
	* [Create a Project](#create-a-project)
	* [Run Rails App](#run-rails-app)
* [App With Database](#app-with-database)
	* [Create App](#create-app-with-database)
	* [Setup Database](#setup-app-with-database)
	* [Run App](#run-app-with-database)

<a name="getting-started"></a>
## Getting Started

<a name="environment-values"></a>
### Environment Values

Create `.env` file by copying from `env.example`

```
cp env.example .env
```


<a name="files-and-folder"></a>
### Files and Folders

This setup suggests with below folders structure. You should have a main folders
that holds 2 folders:

1. apps - where you setup your multiple ruby/rails projects
1. dockery - where you checkout Dockery project. All commands (`docker-sync`, `docker-compose`, `synch.sh`)
should be run in this folder.

```
<main_folder>
|
|--apps/ (contains multple Ruby/Rails projects)
|  |-- blog/
|  |-- other-awesome-project/
|
|--dockery/ (Dockery project)
```

This structure is define by below `.env` entry

```
APPLICATIONS_PATH=../apps
```

If you wish to have different place to hold your projects you'll have to change
that entry.

`ruby` workspace has 2 versions of `volume` mapping; `cached` and `dockery-sync`. This is
because for Mac, it requires performance boost with Docker Sync. Refer to
[Docker-Sync-Specific Setup](#docker-sync-specific-setup) for more details. Basically copy either
`docker-compose.cached.yml` or `docker-compose.docker-sync.yml` to `docker-compose.override.yml`
in order to get your `ruby` workspace volumes mapped to your host machine.

<a name="docker-sync-specific-setup"></a>
### Docker-Sync-Specific Setup

Docker on Mac is known to have performance issue with its file syncing.
To improve the speed, we can use [Docker Sync](http://docker-sync.io).
`docker-sync.yml` is Docker Sync configuration file which maps applications
and bundle folders.

Run below command to start Docker Sync service

```
./sync.sh
```

*Note:* Under the hood, the script runs `docker-sync clean` and
`docker-sync start` to start fresh with `docker-sync` service.
If the folders to be managed by `docker-sync` are missing, this script will
create them for you.

If you wish to stop the `docker-sync` service, run `docker-sync stop`.

Refer to this Docker Sync [commands wiki](https://github.com/EugenMayer/docker-sync/wiki/2.1-sync-commands) for other available commands.

`docker-compose.dockery-sync.yml` is the override file which overrides the volumes
configurations from `docker-compose.yml` to Docker Sync managed volumes.

**There are 2 ways to use this override file.**

- #### 1st option

> First option is to use `docker-compose -f` flag as shown below:

```
docker-compose -f docker-compose.yml -f docker-compose.docker-sync.yml up -d ruby
```

- #### 2nd option

> Second option, is to copy `docker-compose.docker-sync.yml` to `docker-compose.override.yml`.
`docker-compose` by default will read both `docker-compose.yml` as default
and `docker-compose.override.yml` as override configurations.

```
cp docker-compose.docker-sync.yml docker-compose.override.yml

docker-compose up -d ruby
```

Each time you changed something in .`env` that affects `dockery-sync` source folder
, i.e. `$MY_RUBY_VERSION`, you will need to run `./sync.sh` to resync your project folder.

<a name="create-a-project"></a>
### Create a Project

If just want to start fresh and the project folder is empty, you can generate
new rails project with below command.

```
docker-compose run ruby rails new blog
```

This will create `blog` app within the `apps` folder.

<a name="run-rails-app"></a>
### Run Rails App

Set the application folder name that you wish to run.
For example, if you wish to run `blog` application, you set that project
folder name to `APP` key in
`.env` file

```
APP=blog
```

Assume you already have an app named `blog` in `apps` folder.
```
docker-compose up -d ruby
```

You could also override the `APP` env value inline with the command.

```
APP=blog docker-compose up -d ruby
```

The Rails app will be available at http://localhost:8000


<a name="app-with-database"></a>
## App With Database

<a name="create-app-with-database"></a>
## Create App

Run below command to create new rails `blog` project with postgresql database.

```
docker-compose run ruby rails new blog --database=postgresql
```

*Note:* You can switch `postgresql` to `mysql` if that is your choice of database.

There is a helper script, `rails-new` that will do the same but will create following
database.yml.

```
docker-compose run ruby rails-new blog postgresql
```

```
# database.yml
development: &default
  adapter: <%= ENV.fetch("DB_ADAPTER") %>
  host: <%= ENV.fetch("DB_HOST") %>
  port: <%= ENV.fetch("DB_PORT") %>
  username: <%= ENV.fetch("DB_USER") %>
  password: <%= ENV.fetch("DB_PASSWORD") %>
  database: <%= ENV.fetch("APP_NAME") + "_development" %>
  encoding: utf8
  min_messages: warning
  pool: <%= Integer(ENV.fetch("DB_POOL", 5)) %>
  reaping_frequency: <%= Integer(ENV.fetch("DB_REAPING_FREQUENCY", 10)) %>
  timeout: 5000

test:
  <<: *default
  database: <%= ENV.fetch("APP_NAME") + "_test" %>

production: &deploy
  encoding: utf8
  min_messages: warning
  pool: <%= [Integer(ENV.fetch("MAX_THREADS", 5)), Integer(ENV.fetch("DB_POOL", 5))].max %>
  timeout: 5000
  url:  <%= ENV.fetch("DATABASE_URL", "") %>
```

<a name="setup-app-with-database"></a>
## Setup Database

Start the postgresql service in the background.

```
docker-compose run up -d postgres
```

Bundle install.


```
docker-compose run ruby bash -c 'cd blog && bundle check || bundle install'
```

Setup the database.


```
docker-compose run ruby bash -c 'cd blog && bin/rails db:setup'
```

Migrate database.


```
docker-compose run ruby bash -c 'cd blog && bin/rails db:migrate'
```

<a name="run-app-with-database"></a>
## Run App

Run the app.

```
APP=blog docker-compose up -d ruby postgres
```

The Rails app will be available at http://localhost:8000
