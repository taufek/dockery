# Dockery [![Build Status](https://travis-ci.org/taufek/dockery.svg?branch=master)](https://travis-ci.org/taufek/dockery) [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Docker for Ruby. Docker Containers for Ruby Development Enviroment. It is heavily inspired by
[Laradock](https://github.com/laradock/laradock) project.

* [Setup Guide](#setup-guide)
	* [Files and Folders](#files-and-folders)
	* [Create a Project](#create-a-project)
	* [Mac-Specific Setup](#mac-specific-setup)
	* [Run Rails App](#run-rails-app)

<a name="setup-guide"></a>
## Setup Guide

<a name="files-and-folder"></a>
### Files and Folders

This setup suggests with below folders structure. You should have a main folders
that holds 2 folders:

1. apps - where you setup your multiple ruby/rails projects
1. dockery - where you checkout Dockery project.

```
<main_folder>
|
|--apps/ (contains Ruby/Rails projects)
|  |-- blog/
|  |-- other-awesome-project/
|
|--dockery/ (RubyDock project)
```

This structure is define by below `.env` entry

```
APPLICATIONS_PATH=../apps
```

If you wish to have different place to hold your projects you'll have to change
that entry.

<a name="create-a-project"></a>
### Create a Project

Create `.env` file by copying from `.env.example`

```
cp .env.example .env
```

Set the application folder name that you wish to run. For example, if you wish
to run `blog` application, you set that project folder name to `APP` key in
`.env` file

```
APP=blog
```

If just want to start fresh and the project folder is empty, you can generate
new rails project with below command.

```
docker-compose run ruby rails-new
```

<a name="mac-specific-setup"></a>
### Mac-Specific Setup

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
docker-compose up -d -f docker-compose.yml -f docker-compose.mac.yml ruby
```

Second option, is to copy `docker-compose.mac.yml` to `docker-compose.override.yml`.
`docker-compose` by default will read both `docker-compose.yml` as default
and `docker-compose.override.yml` as override configurations.

```
cp docker-compose.mac.yml docker-compose.override.yml

docker-compose up -d ruby
```

Each time you change an entry that related to your project path, you will need
to run `./resync.sh` to resync your project folder.

<a name="run-rails-app"></a>
### Run Rails App

Assume you already have an app named `blog` in `apps` folder.
```
docker-compose up ruby -d
```

The Rails app will be available at http://localhost:8000
