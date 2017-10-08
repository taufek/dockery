#!/bin/bash

echo 'Resyncing...'

docker-compose down -v
docker-sync clean
docker-sync start
docker-sync sync

echo 'Done'
