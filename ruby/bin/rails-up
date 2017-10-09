#!/bin/sh

rm tmp/pids/server.pid
bundle check || bundle install
rails s -b 0.0.0.0
