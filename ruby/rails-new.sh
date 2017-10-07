#!/bin/bash

cp /template/Gemfile /app/Gemfile
touch /app/Gemfile.lock

rails new . --force --postgresql
