# Dockery
Docker for Ruby. Docker Containers for Ruby Development Enviroment. It is heavily inspired by
[Laradock](https://github.com/laradock/laradock) project.

## Setup Guide

This setup requires below folders structure. You should have a main folders
that holds 2 folders:

1. apps - where you setup your multiple ruby/rails projects
1. rubydock - where you checkout Dockery project.

```
<main_folder>
|
|--apps/ (contains Ruby/Rails projects)
|  |-- project1/
|  |-- project2/
|
|--dockery/ (RubyDock project)
```

### Mac Specific Setup

Docker on Mac is known to have performance issue with its file syncing.
To improve the speed, we can use [Docker Sync](http://docker-sync.io).
`docker-sync.yml` is Docker Sync configuration file which maps applications
and bundle folders.

Run below command to start Docker Sync service

```
docker-sync start
```

Refer to this Docker Sync [commands wiki](https://github.com/EugenMayer/docker-sync/wiki/2.1-sync-commands) for other available commands.

`docker-compose.mac.yml` is the override file which overrides the volumes
configurations from `docker-compose.yml` to Docker Sync managed volumes.
There are 2 ways to use this override file.

First option is to use `docker-compose -f` flag as shown below:

```
docker-compose up ruby -f docker-compose.yml -f docker-compose.mac.yml up -d
```

Second option, is to copy `docker-compose.mac.yml` to `docker-compose.override.yml`.
`docker-compose` by default will read both `docker-compose.yml` as default
and `docker-compose.override.yml` as override configurations.

```
cp docker-compose.mac.yml docker-compose.override.yml

docker-compse up ruby -d
```



