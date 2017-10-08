#!/bin/bash

echo 'Resyncing...'

docker-compose down
docker-sync clean
docker-sync start
docker-sync sync

echo 'Done'
