#!/bin/bash

echo 'Syncing...'

export `sed '/#/d' .env`

docker-compose down -v
docker-sync clean

docker-sync start
docker-sync sync

echo 'Done'
